From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 06 Jul 2006 12:49:59 +0200
Message-ID: <44ACEAD7.40007@trash.net>
References: <W8195318669268441152182124@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "bdschuym@pandora.be" <bdschuym@telenet.be>
In-Reply-To: <W8195318669268441152182124@nocme1bl6.telenet-ops.be>
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

bdschuym@pandora.be wrote:
>>----- Oorspronkelijk bericht -----
>>Van: Patrick McHardy [mailto:kaber@trash.net]
>>Verzonden: dinsdag, juli 4, 2006 11:27 AM
>>Aan: 'Bart De Schuymer'
>>CC: 'Netfilter Development Mailinglist'
>>Onderwerp: Re: RFC: Disable defered bridge hooks by default
>>
>>Patrick McHardy wrote:
>>
>>>Finally got to taking care of the first part of getting
>>>rid of the defered bridge hooks. Bart, does this look
>>>correct to you? This stuff confuses me badly :) Thanks.
>>>
> 
> 
> Looks good, but please use deferred instead of defered :)

Sure :) I tested it in the meantime and it crashes somewhere,
will repost after fixing that.
