From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070707 kernel
Date: Fri, 13 Jul 2007 17:03:54 +0200
Message-ID: <4697945A.8090806@trash.net>
References: <46925543.6060205@trash.net> <46925580.9030608@trash.net>
	<Pine.LNX.4.64.0707091737550.2887@fbirervta.pbzchgretzou.qr>
	<200707131418.l6DEIudN010879@toshiba.co.jp>
	<Pine.LNX.4.64.0707131658590.25352@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707131658590.25352@fbirervta.pbzchgretzou.qr>
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
> On Jul 13 2007 23:18, Yasuyuki KOZAKAI wrote:
> 
>>JFYI: I've fixed compile error in the case of NO_SHARED_LIBS=1. The
>>function name for initialization needs to be _init, not
>>libipt_connlimit_init.
> 
> 
> Uhm, that's why there is __attribute__((constructor)). Because *having* an
> _init in a shared library has often failed on me. Example:
> 
> [...]


It works for other extensions, so it will also work for this one.
