From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: libiptc/rules with MAC match
Date: Wed, 12 Feb 2003 21:13:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <647994215.20030212211303@habitat-b.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello netfilter-devel ppl,

  I got some questions concerning libiptc and acquiring rules and setting
  rules with it. I read all documents I could find, as well as part of
  iptable sources and the header files etc. .
  Yet there's some things I don't seem to get straight.

  If I fetch the rules of a chain, I'll get a struct ipt_entry (well,
  actually a pointer, but this won'T matter for now). There's all
  kinda src,dst ips,netmasks etc. flags.

  Within this struct there an ipt_ip struct, with the properties:
  char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
  unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];

  What's the difference between those two ?

  The other thing is, assuming I have a rule, which matches a MAC
  Adress, how do I get the MAC Adress (and if such a matching is in
  the rule). From what I've understood, there's the target_offset
  counter, which helps me on that.
  IT seems to describe the size of a memmory block, so basicly, if I
  sub the size of the ipt_entry structure, I get the size of the
  matches, or actually, behind the ipt_entry in the memory space there
  seems to be a flat array, with matches ?
  The other thing is, if I want to set such a rule, with mac matching,
  even if I properly construct that memory block, what do I need to
  take care about, alignment stuff etc. ?

  Even more intriguing is the following question to me:

  I can see, there's a function to get the target.
  Assuming I want to set a rule, how do I set the target properly, and
  how do I set a MAC matching ?

  I couldn't find anything in particular on that and would apprechiate
  any help on that.
  

-- 
Best regards,
 DarKRaveR                          mailto:DarKRaveR@habitat-b.de
