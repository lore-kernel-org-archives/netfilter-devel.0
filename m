From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re: libiptc/rules with MAC match
Date: Thu, 13 Feb 2003 06:14:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15940504432.20030213061453@habitat-b.de>
References: <647994215.20030212211303@habitat-b.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <647994215.20030212211303@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello list,

Okay, I kinda tried out some things.

I use libiptc to get a rule ...
there's destinations source, etc.
if target_offset is bigger than sizeof(struct ipt_entry),
there's a match present.
elems points to the first match ...
If I cast it to ipt_entry_match, and then check the vars in that
structure, I can see various sizes etc.
u.user.name gives me 'mac'.

but, what I am wondering:
where can I find the actual mac address ?
there ipt_entry_match.data, but the data in there didn't make too much
sense ...

Can anyone help me out on that ?

And how can I construct a rule myself, that does mac matching ?
I am kinda stuck !

Wednesday, February 12, 2003, 9:13:03 PM, you wrote:

D> Hello netfilter-devel ppl,

D>   I got some questions concerning libiptc and acquiring rules and setting
D>   rules with it. I read all documents I could find, as well as part of
D>   iptable sources and the header files etc. .
D>   Yet there's some things I don't seem to get straight.

D>   If I fetch the rules of a chain, I'll get a struct ipt_entry (well,
D>   actually a pointer, but this won'T matter for now). There's all
D>   kinda src,dst ips,netmasks etc. flags.

D>   Within this struct there an ipt_ip struct, with the properties:
D>   char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
D>   unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];

D>   What's the difference between those two ?

D>   The other thing is, assuming I have a rule, which matches a MAC
D>   Adress, how do I get the MAC Adress (and if such a matching is in
D>   the rule). From what I've understood, there's the target_offset
D>   counter, which helps me on that.
D>   IT seems to describe the size of a memmory block, so basicly, if I
D>   sub the size of the ipt_entry structure, I get the size of the
D>   matches, or actually, behind the ipt_entry in the memory space there
D>   seems to be a flat array, with matches ?
D>   The other thing is, if I want to set such a rule, with mac matching,
D>   even if I properly construct that memory block, what do I need to
D>   take care about, alignment stuff etc. ?

D>   Even more intriguing is the following question to me:

D>   I can see, there's a function to get the target.
D>   Assuming I want to set a rule, how do I set the target properly, and
D>   how do I set a MAC matching ?

D>   I couldn't find anything in particular on that and would apprechiate
D>   any help on that.
  
-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
