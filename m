From: Peteris Krumins <newsgroups@lf.lv>
Subject: iptc_zerro_entries segfaults, why?
Date: Thu, 8 May 2003 01:26:48 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <136554192396.20030508012648@lf.lv>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
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

Hi,

 i am developing some tool for me which uses libtc to manage rules
 etc.
 unfortunately iptc_zerro_entries does not want to work: as soon as
 called - segfaults.

 code (simpified, might have a typo) is like this:

--/
 char *table = "filter";
 ...
 iptc_handle_t h;
 int ret=0;
 const char *c = NULL;
 h = iptc_init(table);

 if (!h){
    .. err handler
 }
 for (c=iptc_first_chain(&h);
      c;
      c=iptc_next_chain(&h)) {

      printf("in filter found: '%s'\n",c);
      printf("zeroing..\n");
      ret = iptc_zerro_entries(c,&h);
      /* segfaults right here [1] */
      ...
 }
--/

[1] i see the prototype of iptc_zerro_entries:
    TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle);
    IPT_CHAINLABEL is 'typedef char ipt_chainlabel[32]'

    exactly the same thing is done in iptables, only iptables have
    zero_entries function.

 so what could be wrong?

 compile w/:
gcc -W -Wall -I<ipt include dir> -rdynamic \
-o <executable> <src> \
<path to>/iptables.o <path to/libiptc>/libiptc.a \
-ldl -lnsl


P.Krumins
