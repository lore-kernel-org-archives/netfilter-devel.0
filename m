From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070707 kernel
Date: Fri, 13 Jul 2007 17:16:43 +0200
Message-ID: <4697975B.5010109@trash.net>
References: <46925543.6060205@trash.net> <46925580.9030608@trash.net>
	<Pine.LNX.4.64.0707091737550.2887@fbirervta.pbzchgretzou.qr>
	<200707131418.l6DEIudN010879@toshiba.co.jp>
	<Pine.LNX.4.64.0707131658590.25352@fbirervta.pbzchgretzou.qr>
	<4697945A.8090806@trash.net>
	<Pine.LNX.4.64.0707131710150.25352@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707131710150.25352@fbirervta.pbzchgretzou.qr>
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
> On Jul 13 2007 17:03, Patrick McHardy wrote:
> 
>>It works for other extensions, so it will also work for this one.
>>
> 
> 
> Yes of course.
> 
> #define _init __attribute__((constructor)) my_init
> 
> That's exactly the same as before (for the NO_SHARED_LIBS=0 case).
> For NO_SHARED_LIBS=1, _init is replaced by connlimit_init instead. Also ok.
> Well, connlimit_init is not that far from libipt_connlimit_init,
> and I'd prefer the latter because the former is already used for
> 
>   .init = connlimit_init,


Frankly, I'm not too interested in this as long as it works.
So if you have any dislikes with the current code, please
send a patch.
