From: "Sascha" <listuser@epygi.de>
Subject: iptables.c changes submitted argv value
Date: Wed, 11 Aug 2004 14:09:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <IDEAKKJENKGNPNLKJKODEEAECAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

can anyone tell me why it's necessary to set optarg[0] in case of '!' to
'\0'?

iptables.c line 2010
---
case 1: /* non option */
	if (optarg[0] == '!' && optarg[1] == '\0') {
      	if (invert)
            	exit_error(PARAMETER_PROBLEM,
                  		"multiple consecutive ! not"
                              " allowed");
                  invert = TRUE;
----->            optarg[0] = '\0';
                  continue;
       }
     	 printf("Bad argument `%s'\n", optarg);
       exit_tryhelp(2);
---

I don't search a solution for this, only an explanation.

The Problem is i wanna build a deamon with iptables, which load's a static
ruleset on init. In case of:

---
deamon -A INPUT -m mark ! --mark 0 -j IDS
deamon -A OUTPUT -m mark ! --mark 0 -j IDS
---

... my init crashes with "Bad Argument ''", because do_command in iptables
changes my values ('!' to '\0')
for the ! in the second line (output-rule) ...

Thanks & Regards
Sascha
