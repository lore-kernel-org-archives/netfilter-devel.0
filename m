From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070707 kernel
Date: Wed, 11 Jul 2007 20:25:53 +0200
Message-ID: <469520B1.1060109@trash.net>
References: <Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
	<200707100630.l6A6UB8Q000847@toshiba.co.jp>
	<Pine.LNX.4.64.0707111933530.11053@fbirervta.pbzchgretzou.qr>
	<46951BA9.4010809@trash.net>
	<Pine.LNX.4.64.0707112017450.11053@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707112017450.11053@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jul 11 2007 20:04, Patrick McHardy wrote:
> 
>>>[...]
>>>
>>>But, nf_ct_get_tuplepr() returns with 1, and I am not sure why.
>>
>>Thats expected I guess, 1 is usually "success" for the tuple parsing
>>functions.
>>
> 
> Such functions should at best return bool :(
> Anyway, please take this patch (to be folded onto xt_connlimit) -
> runtime-'tested' this time.


Looks good. I've folded it into the original patch, thanks Jan.
