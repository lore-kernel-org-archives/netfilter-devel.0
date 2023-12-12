Received: from pepin.polanet.pl (pepin.polanet.pl [193.34.52.2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CFE113
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 10:44:16 -0800 (PST)
Date: Tue, 12 Dec 2023 19:44:13 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] log NAT events using IPFIX
Message-ID: <20231212184413.GA2168@polanet.pl>
References: <20231210201705.GA16025@polanet.pl>
 <ZXhkbfE9ju7uiFNN@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <ZXhkbfE9ju7uiFNN@calendula>
User-Agent: Mutt/1.5.20 (2009-06-14)

Hi,

On Tue, Dec 12, 2023 at 14:47:25 +0100, Pablo Neira Ayuso wrote:

> Would you mind to split this large patch is smaller chunks, logic is:
> 
> - one logical update per patch
> 
> with a description on the rationale, probably in 3-4 patches?

Sure.

>>  /* Information Element Identifiers as of draft-ietf-ipfix-info-11.txt */
>> +/* https://www.iana.org/assignments/ipfix/ipfix.xhtml */
>>  enum {
>>  	IPFIX_octetDeltaCount		= 1,
>>  	IPFIX_packetDeltaCount		= 2,
>> -	/* reserved */
>> +	/* deltaFlowCount */
>>  	IPFIX_protocolIdentifier	= 4,
>>  	IPFIX_classOfServiceIPv4	= 5,
>>  	IPFIX_tcpControlBits		= 6,
>> @@ -73,24 +74,24 @@ enum {
>>  	IPFIX_flowLabelIPv6		= 31,
>>  	IPFIX_icmpTypeCodeIPv4		= 32,
>>  	IPFIX_igmpType			= 33,
>> -	/* reserved */
>> -	/* reserved */
>> +	/* samplingInterval */
>> +	/* samplingAlgorithm */
>>  	IPFIX_flowActiveTimeOut		= 36,
>>  	IPFIX_flowInactiveTimeout	= 37,
>> -	/* reserved */
>> -	/* reserved */
>> +	/* engineType */
>> +	/* engineId */
> 
> These comments updates are to get this in sync with RFC? What is the
> intention?

Well, the list was already there, but based on older document. Link to
current one is added at the top of this chunk:
	/* https://www.iana.org/assignments/ipfix/ipfix.xhtml */

I could have replaced the comments with actual assignments, like:

	IPFIX_engineId			= 41

but I personally don't like creating entities that are not used in the
rest of the code. I personally prefer doing (uncommenting) this on entry-by-entry
basis, when something get's actually implemented.
This approach gives some insight about implementation status.

>> +		Assigned for NetFlow v9 compatibility
>> +		postIpDiffServCodePoint
>> +		plicationFactor
>> +		className
>> +		classificationEngineId
>> +		layer2packetSectionOffset
>> +		layer2packetSectionSize
>> +		layer2packetSectionData
>> +	105-127	Assigned for NetFlow v9 compatibility	*/
>>  	IPFIX_bgpNextAdjacentAsNumber	= 128,
>>  	IPFIX_bgpPrevAdjacentAsNumber	= 129,
>>  	IPFIX_exporterIPv4Address	= 130,

There the rationale was - up to this point we got _all_ the assignments
(continuously). But as we go further, there is more and more data types
that won't be ever implemented.

Actually the question should be: what was the purpose of this listing?

https://git.netfilter.org/ulogd2/commit/include/ulogd/ipfix_protocol.h?id=570f2229563fb8101b1ba0369eeda1f19dbc88ee

Anyway - this chunk is actually redundant (except from the source
document), so I think I'll simply drop this. No need for copy&paste IANA.

>> +++ b/input/flow/ulogd_inpflow_NFCT.c
>> @@ -379,10 +379,10 @@ static struct ulogd_key nfct_okeys[] = {
>>  		.type 	= ULOGD_RET_UINT32,
>>  		.flags 	= ULOGD_RETF_NONE,
>>  		.name	= "flow.start.usec",
>> -		.ipfix	= {
>> +	/*	.ipfix	= {
>>  			.vendor		= IPFIX_VENDOR_IETF,
>> -			.field_id	= IPFIX_flowStartMicroSeconds,
>> -		},
>> +			.field_id	= IPFIX_flowStartMicroSeconds,	-- this entry expects absolute total value, not the subsecond remainder
>> +		},	*/
>>  	},
>>  	{
>>  		.type	= ULOGD_RET_UINT32,
>> @@ -397,10 +397,10 @@ static struct ulogd_key nfct_okeys[] = {
>>  		.type	= ULOGD_RET_UINT32,
>>  		.flags	= ULOGD_RETF_NONE,
>>  		.name	= "flow.end.usec",
>> -		.ipfix	= {
>> +	/*	.ipfix	= {
>>  			.vendor		= IPFIX_VENDOR_IETF,
>> -			.field_id	= IPFIX_flowEndSeconds,
>> -		},
>> +			.field_id	= IPFIX_flowEndMicroSeconds,	-- this entry expects absolute total value, not the subsecond remainder
>> +		},	*/
> 
> This is commented out, if it needs to go, better place this in a patch
> and explain why you propose this change?

These are disabled, because they're simply not correct. Left in place as a
comment just to left a warning for future updates.

https://git.netfilter.org/ulogd2/commit/input/flow/ulogd_inpflow_NFCT.c?id=6b4b8aa3a9612f1c92e885ac71a503321cabd69e

I might as well simply change it to ".ipfix = { }".

-- 
Tomasz Pala <gotar@pld-linux.org>
