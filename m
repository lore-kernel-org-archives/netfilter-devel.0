From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_MARK useless line
Date: Sun, 7 Jan 2007 16:14:51 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701071613520.4365@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
	<20070107141557.GB13543@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20070107141557.GB13543@prithivi.gnumonks.org>
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


On Jan 7 2007 15:15, Harald Welte wrote:
>On Fri, Dec 29, 2006 at 05:54:07PM +0100, Jan Engelhardt wrote:
>> Hi,
>> 
>> in linux-2.6.20-rc2/net/netfilter/xt_MARK.c one can find
>> 
>>         if((*pskb)->mark != markinfo->mark)
>>                 (*pskb)->mark = markinfo->mark;
>> 
>> would not it be simpler just to set the mark? Or are comparison-jumps 
>> like these 'cheaper' than assignments? (I don't think so.)
>
>I don't really know. I think the intention might have been to prevent
>writes to shared data structures, in order to reduce cache ping-pong on
>SMP.  However, unlesss some really complex and rare event happens, this
>skb will never be processed asynchronously and thus not be used on any
>other CPU.

In other words, your conclusion is ... - (R)emove/(K)eep?
(For the record, it's anywhere where something is set, that is, MARK, CONNMARK,
SECMARK, TOS, ECN, and so on, everywhere you have XT_CONTINUE)


	-`J'
-- 
