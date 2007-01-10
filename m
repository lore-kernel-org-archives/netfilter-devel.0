From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_MARK useless line
Date: Wed, 10 Jan 2007 12:03:28 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701101203200.3029@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
	<20070107141557.GB13543@prithivi.gnumonks.org>
	<Pine.LNX.4.61.0701071613520.4365@yvahk01.tjqt.qr>
	<45A18EE8.5080909@snapgear.com> <45A47F66.2050603@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A47F66.2050603@trash.net>
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


On Jan 10 2007 06:53, Patrick McHardy wrote:
>> 
>> Some of these may be leftover from when NFC_ALTERED existed?
>
>That sounds like the most likely explanation. Looking at 2.4:
>
>        if((*pskb)->nfmark != markinfo->mark) {
>                (*pskb)->nfmark = markinfo->mark;
>                (*pskb)->nfcache |= NFC_ALTERED;
>
>        }
>
>I vote for removing this (also in CONNMARK, CONNSECMARK, ...).
>

I'll whack it up.


	-`J'
-- 
