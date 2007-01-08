From: Philip Craig <philipc@snapgear.com>
Subject: Re: xt_MARK useless line
Date: Mon, 08 Jan 2007 10:23:04 +1000
Message-ID: <45A18EE8.5080909@snapgear.com>
References: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>	<20070107141557.GB13543@prithivi.gnumonks.org>
	<Pine.LNX.4.61.0701071613520.4365@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701071613520.4365@yvahk01.tjqt.qr>
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
> On Jan 7 2007 15:15, Harald Welte wrote:
>> On Fri, Dec 29, 2006 at 05:54:07PM +0100, Jan Engelhardt wrote:
>>> Hi,
>>>
>>> in linux-2.6.20-rc2/net/netfilter/xt_MARK.c one can find
>>>
>>>         if((*pskb)->mark != markinfo->mark)
>>>                 (*pskb)->mark = markinfo->mark;
>>>
>>> would not it be simpler just to set the mark? Or are comparison-jumps 
>>> like these 'cheaper' than assignments? (I don't think so.)
>> I don't really know. I think the intention might have been to prevent
>> writes to shared data structures, in order to reduce cache ping-pong on
>> SMP.  However, unlesss some really complex and rare event happens, this
>> skb will never be processed asynchronously and thus not be used on any
>> other CPU.
> 
> In other words, your conclusion is ... - (R)emove/(K)eep?
> (For the record, it's anywhere where something is set, that is, MARK, CONNMARK,
> SECMARK, TOS, ECN, and so on, everywhere you have XT_CONTINUE)

Some of these may be leftover from when NFC_ALTERED existed?
