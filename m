From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: accounting
Date: Thu, 13 Feb 2003 20:10:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8490663256.20030213201052@habitat-b.de>
References: <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com>
 <17921743084.20030213010212@habitat-b.de>
 <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com>
 <20030213164648.GI30133@calix.csn.tu-chemnitz.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
In-Reply-To: <20030213164648.GI30133@calix.csn.tu-chemnitz.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Thomas,

Thnx for that pointer, seems really nice for the purpose it was done
for, and I plan on having features like that in the end, but there's
unfortunately so much more, the app I work on needs to take care off
:-(. it starts with things like having a group of people which
administer the system for different location and therefore having
different rights etc. and the way the user interacts with the
system...

So, it won't help me for now, save me time, maybe in a later stage,
when I can borrow some ideas or something :-)
But maybe this works fine for andrej ...

Thursday, February 13, 2003, 5:46:48 PM, you wrote:

TP> Hi,
 
TP> On Wed, Feb 12, 2003 at 11:27:24PM +0000, Andrej Ricnik wrote:

>> I've been searching for a decent Linux IP accounting
>> solution (I have a 5GB limit a month and don't want
>> to pay a penalty just because the kids are greedy :})
>> but couldn't find anything easy to use/decent that would
>> allow me to keep track of traffic per IP and/or user
>> and stop traffic from that IP/user once their "fair share"
>> is used up ...
>> 
>> So I was wondering how difficult it would be to intercept
>> logging information from userland, and where to find
>> info's on how to do it.

TP> as for the logging of traffic, this is really easy. You could use an
TP> iptables rule, as DarKRaveR suggested, or just use snmp
TP> (interfaces.ifTable.ifEntry.ifInOctets*).

TP> But for the assurance of a given limit, you will need a lot more.

TP> On Thu, Feb 13, 2003 at 01:02:12AM +0100, DarKRaveR wrote:

>> I kinda face the same problem here, just that I want the whole
>> enchilada database backed, and the rules should be generated from a
>> database with user information.
>> I am working on some c++ progs etc. to make a solution for our
>> scenario ... but it's all still earliest work in progress.
>> 
>> it's a pitty, I couldn'T find anythign usefull :-( could have save me
>> hours of work :-)

TP> Stop working, look here:
TP> https://rnvs.informatik.tu-chemnitz.de/Dynshaper/

TP> It is already up and running, doing everything you can dream of: shaping
TP> to a given limit, dynamic traffic adjustment based on long term traffic
TP> analysis, database backend, IP based class allocation, Web-Frontend,
TP> Database-Backend, ... and it's GPL!

TP> The only disadvantage: it seems there is only a German documentation.

TP> Ciao!
TP>     Thomas


-- 
Best regards,
 DarKRaveR (Sven)                           mailto:DarKRaveR@habitat-b.de
