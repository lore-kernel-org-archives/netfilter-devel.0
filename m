From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: libiptc/rules with MAC match
Date: Thu, 13 Feb 2003 12:34:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <18963299109.20030213123448@habitat-b.de>
References: <647994215.20030212211303@habitat-b.de>
 <15940504432.20030213061453@habitat-b.de>
 <20030213105503.GH30133@calix.csn.tu-chemnitz.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Cc: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
In-Reply-To: <20030213105503.GH30133@calix.csn.tu-chemnitz.de>
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

Thanx for you email, this looks really promising, I think ...
Okay, further down are some more remarks ...

Thursday, February 13, 2003, 11:55:03 AM, you wrote:

TP> Hi,

TP> On Thu, Feb 13, 2003 at 06:14:53AM +0100, DarKRaveR wrote:

>> I use libiptc to get a rule ...

TP> ok so far.

>> there's destinations source, etc.

TP> yep

>> if target_offset is bigger than sizeof(struct ipt_entry),
>> there's a match present.

TP> yep

>> elems points to the first match ...

TP> sorry, you lost me.
TP> I'll just describe what I would do, from the point where you had
TP> ipt_entry, ok? If this is what you did, just skip this part.

Okay, I see, the way you do it, is pretty much the way it is done in
IPT_ITERATE_MATCH function? in one of the header files ...
at least it looks familiar.

anyway, I came to the conclusion that ...

(void *)e+offset .. is the same as (void *)e+sizeof(struct ipt_entry)
and that this address is the same stored in unsigned char elems[0]
(within ipt_entry, which is a one char array or basicly a char pointer)
so (void *)e+sizeof(struct ipt_entry) is the same as (void *)elems.

But from there, you have to work with the u.match_size ...
Just a thought, using a pointer to create some sort of 'linked list'
like in the case of ipt_entry, and the pointer, pointing to the
matches and targets, might be a cleaner design ? you wouldn't have to
calculate memory offsets and use so much pointer arithmetic in your
code, and maybe move the dirty stuff where it belongs, in iptc
somewhere under the hood :-)

But that's just a general thought ...

TP> struct ipt_entry *e;
TP> struct ipt_entry_match *em;
TP> unsigned int offset;

TP> for(offset = sizeof(struct ipt_entry);
TP>     offset < e->target_offset;
TP>     offset += em->u.match_size) 
TP> { 
TP>     em = (void* )e + offset;
TP> }

>> If I cast it to ipt_entry_match, and then check the vars in that
>> structure, I can see various sizes etc.
>> u.user.name gives me 'mac'.

TP> this looks promising

That's what I thought myself ;-)

>> but, what I am wondering:
>> where can I find the actual mac address ?
>> there ipt_entry_match.data, but the data in there didn't make too much
>> sense ...

TP> Have you had a look at $IPTABLES_SRC/extensions/libipt_mac.c ?  It is

No unfortunately not, reading all sources was a little bit too much,
at the current situation, but I guess, I'll have to do that :-)

TP> just right there, at your fingertips. Its the first ETH_ALEN unsigned
chars in match->>data. Just look at the function print() in the above
TP> mentioned file and try to parse the output as they do it. Works for them
TP> and works for me, why shouldn't it work for you? ;-)

Okay, I will check back on that, I guess, my own routine ... aight
*DAMN* thats the point, THANX ! I was runnign through the data
searching for a \0 just because I read unsigned char pointer, what a
fool I am, esp. when my MAC starts with 00: ... okay, good point, that
HELPED alot, I think, I was/am just too tired ;-) maybe I should sleep
some time ...

>> Can anyone help me out on that ?

TP> Hope I did.

Sure did, many thanx, sometimes things are so obvious and just won'T
pop up to your eyes ...

>> And how can I construct a rule myself, that does mac matching ?

TP> iptables -I $chain -m mac --mac-source ...
TP> or have a look at parse_mac() in libipt_mac.c

I'll stick to the latter I fear, spawning iptables is not an option,
if you want to update a pile of rules (delete/add) in a set of a dozen
chains with approx 200 rules each ;-) that would not be too much fun I
assume :-)

TP> Happy hacking,
TP>     Thomas

Yeah, thanx, I'll try that tomorrow I think, tonight I will be too
tired, after being up for 30 hrs ;-)

I really appreciate your help ..

-- 
Best regards,
 DarKRaveR (Sven)                           mailto:DarKRaveR@habitat-b.de

P.S.: In Deutsch wärs einfacher ;-) und wenn etwas unverständlich ist,
nochmal fragen, ich schlafe schon halb :-O
