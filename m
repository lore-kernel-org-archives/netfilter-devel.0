From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: ip_contrack table full ?
Date: Mon, 17 Feb 2003 14:31:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <12216879671.20030217143118@habitat-b.de>
References: <18436282631.20030216234147@habitat-b.de>
 <20030217130328.GA9541@sunbeam.de.gnumonks.org>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030217130328.GA9541@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Harald,

Yeah, realized that too late, and I am just subscribed to this one,
because of the other things, I am working on. wrecked was the wrong
word, wrecked in the sense of, the roputinr was screwed, or actually,
No user could do anything anymore ...
Sorry again, for posting to the wrong place ...

Monday, February 17, 2003, 2:03:28 PM, you wrote:

HW> On Sun, Feb 16, 2003 at 11:41:47PM +0100, DarKRaveR wrote:
>> Hello list,
>> 
>>   I got an issue with ip_contrack module. I have a router here, with
>>   ip_contrack enabled, because I need the REDIRECT target. Earlier
>>   this day, the system wrecked, because the ip_contrack table was
>>   obviously full. How could this happen, with just 6 users ?

HW> 1) the system doesn't just crash because the table is full.  The system
HW>    can run out of memory, ip_conntrack_max is too big and you don't have 
HW>    enough (free) memory.
HW> 2) this is not a develoment question (but the development list)
HW> 3) see http://www.netfilter.org/documentation/FAQ/netfilter-faq-3.html#ss3.6

>> Best regards,




-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
