From: "Laurence J. Lane" <ljlane@nontoxic.org>
Subject: rules inserted with bad interface name
Date: Fri, 22 Nov 2002 19:12:30 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021123001230.GA23841@ns>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

http://bugs.debian.org/170040

There appears to be an argument parsing bug in iptables, tested with
version 1.2.7a. If -i or -o is used without a space between the
interface and the option, iptables use the option as part of the
interface name. For example:

  iptables -A INPUT -ifoo

That actually appends the rule with the inbound interface 
literally named "-ifoo".

I also fond something else odd. The longopt forms of the interface
options give an error when used with an equal sign. For example:

  root@absolom:~# iptables --append=OUTPUT --out-interface=foo
  iptables v1.2.7a: interface name `--out-interface=foo' must be shorter
  than IFNAMSIZ (15)

That may actually be the same bug because iptables will accept
"--in-interface=" (which weighs in at exactly 15 characters) and 
make it the actual interface name.


Thanks.
