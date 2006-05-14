From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] conntrack: Fix option parsing for ARM
Date: Mon, 15 May 2006 00:43:32 +0200
Message-ID: <4467B294.5060102@eurodev.net>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>	<20060501175353.GD5267@rama>	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>	<20060503111549.GO16562@sunbeam.de.gnumonks.org>	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>	<4460B14E.90506@eurodev.net>	<ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>
	<4464351F.6000402@snapgear.com> <4465437A.9010106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org,
	=?ISO-8859-1?Q?EZE?= <slaveze@gmail.com>,
	Philip Craig <philipc@snapgear.com>, =?ISO-8859-1?Q?S=E9bastien_LAV?=
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4465437A.9010106@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Philip Craig wrote:
> 
>>On 05/10/2006 06:18 PM, Sébastien LAVEZE wrote:
>>
>>
>>>I have problem using the conntrack utility...
>>>It always display the help message and i get the message
>>>conntrack v1.00beta2: Missing arguments...
>>
>>
>>The result of getopt_long() was assigned to a char,
>>which defaults to unsigned on ARM, so the comparison
>>against -1 always failed.
> 
> Thanks for tracking this down Philip. I'm having trouble using
> SVN again .. Pablo, can you try to commit this please?

I'd like to but I can't, it seems that my x509 certificate expired on 
Apr 16:

         Issuer: C=DE, ST=Bayern, L=Erlangen, O=gnumonks.org, CN=Harald 
Welte/emailAddress=hostmaster@gnumonks.org
         Validity
             Not Before: Apr 16 16:55:23 2005 GMT
             Not After : Apr 16 16:55:23 2006 GMT
         Subject: C=DE, ST=Berlin, L=Berlin, O=Netfilter Project, 
OU=Development, CN=pablo/emailAddress=pablo@netfilter.org

I need a renewal, could you tell to Harald about this?

-- 
Pablo
