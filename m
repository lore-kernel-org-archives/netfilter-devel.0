From: "Laurence J. Lane" <ljlane@nontoxic.org>
Subject: Bug#150467: user-defined chains vs. iptables module names
Date: Thu, 20 Jun 2002 07:56:19 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020620145619.GA1404@mail.nontoxic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

http://bugs.debian.org/150467

The problem deals with user-defined chain names clashing with iptables
module names. Basically, it's entirely possible to create a user-defined
chain with the same name (case sensitive)  as a target module, but the
new chain cannot be used as a jump target.

It is a packaging problem of sorts because an upgrade with new modules
can suddenly conflict with existing user-defined chains.

As always, don't shoot the messenger.
