From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: rename-chain option broken in 1.3.6
Date: Thu, 9 Nov 2006 08:51:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611090850310.28584@bizon.gios.gov.pl>
References: <cd6061db0611082051n24bcb5a1hab540f6a1e2d0e8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-521528879-1163058711=:28584"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Laurence J. Lane" <ljlane@debian.org>
In-Reply-To: <cd6061db0611082051n24bcb5a1hab540f6a1e2d0e8c@mail.gmail.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-521528879-1163058711=:28584
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed



On Wed, 8 Nov 2006, Laurence J. Lane wrote:

> Hi,
Hi,

> --rename-chain (-E) appears to be broken in iptables 1.3.6. Reverting
> r6584 and r6584 doesn't appear to affect it.
>
> # iptables -N foo
> # iptables --rename-chain foo bar
> iptables v1.3.6: You need to supply the `-s' option for this command
>
> Try `iptables -h' or 'iptables --help' for more information.
>
> (bugzilla appears to have a mysql server problem at the moment. I
> can't see if this is already reported.)

Interesting problem... ;) How about attached (and inlined) patch?

[PATCH] Fix -E (rename) in iptables/ip6tables

Remove ununsed CHECK entry in commands_v_options.

It makes -E (rename) working again - generic_opt_check
expects options for RENAME not for CHECK at that table index.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur iptables-1.3.6-orig/ip6tables.c iptables-1.3.6/ip6tables.c
--- iptables-1.3.6-orig/ip6tables.c	2006-09-28 18:40:36.000000000 +0200
+++ iptables-1.3.6/ip6tables.c	2006-11-09 08:37:46.000000000 +0100
@@ -170,7 +170,6 @@
  /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
  /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
  /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ','x','x'},
  /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'}
  };

diff -Nur iptables-1.3.6-orig/iptables.c iptables-1.3.6/iptables.c
--- iptables-1.3.6-orig/iptables.c	2006-09-28 18:40:36.000000000 +0200
+++ iptables-1.3.6/iptables.c	2006-11-09 08:37:58.000000000 +0100
@@ -171,7 +171,6 @@
  /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
  /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
  /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ',' ','x','x'},
  /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
  };

---187430788-521528879-1163058711=:28584
Content-Type: APPLICATION/octet-stream; name=iptables-rename-fix.patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0611090851510.28584@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=iptables-rename-fix.patch.gz

H4sIALvdUkUCA62SbU/bMBSFP8+/4n4ra+q8UEhLQFOqLFMroFSANE0TikJy
E6w2duS4LO3Ef19CNmi3dYAyS46dXJ1zbuzn62x07Y1v4BMrgfqwJ5GHGb4H
xoHlKrxdYGGw3G52hFxiJu4RlnzJC4zBG/veKSBXclUrIpFlIY+L4D4QuWKC
FzohEwVZOMdiy/6bkHPGUwjTsNJRSJGjZFEtC6I7jOYEyxwjVcBPI0iEhEt/
Ojr3gQv1+NqkhwrUXf2oW6y6iLGsUq9YyjGmIkno7cqBU7leFWslEpgxoSRc
LDBezxmciAW6YdVnvvhASMySBOh0KZ/+nVp6X7epkCx9PgY9+q2+WSKU0pfk
7/ZN06bmEd0fgjV0Dkynb+vmrwGaWdWJpmn/iGksLKtyAXPo9AfOwbaFVVm4
LlBrYPYGoNWLDa5LwOhO/c+BNx5Npl0DvnfKTu+PCX/5VnYeerX6o3/WQn3l
Xwezi7OJ96VrvFFNje7jjVe59WjU2sbcVMOWU5Pd4NPI35RN4OGYwIt47Kbj
FXC0Z2M3GofDHWhYDRpWazTa49EekTaY/C9UNnH5AYgaYdBbBQAA

---187430788-521528879-1163058711=:28584--
