From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Bug: "You must specify `--icmpv6-type'"
Date: Tue, 13 Feb 2007 10:57:58 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0702131057170.31448@yvahk01.tjqt.qr>
References: <20070209102829.GA31011@roonstrasse.net>
	<200702130301.l1D3159w015381@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: max@duempel.org, netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702130301.l1D3159w015381@toshiba.co.jp>
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

Hi,

On Feb 13 2007 12:01, Yasuyuki KOZAKAI wrote:
>> 
>> According to the ip6tables manpage, the "icmpv6" module is implicitly
>> loaded whenever you specify "-p icmpv6".  It is however only loaded
>> when you also specify "--icmpv6-type".  So either the documentation is
>> wrong, or ip6tables' behaviour is.
>
>This behavior is intended. The matches for protocol are not loaded when you
>specify only '-p protocol', but loaded when you specify extra options of
>them, too. This is to avoid unnecessary loading.

But ip(4)tables always implies -m prot for -p prot. 


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
