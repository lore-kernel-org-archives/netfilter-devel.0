From: Patrick Schaaf <bof@bof.de>
Subject: NEW MATCH -m statmux
Date: Sun, 28 Nov 2004 12:18:58 +0100
Message-ID: <20041128111858.GB4605@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello netfilter developers,

find attached a .tar.gz against pom-ng, introducing a new directory statmux/.
It represents a new match, '-m statmux', which would be typically used
like this:

ipt... -i eth0 -m statmux --statmux-size 4 --statmux-way 0 -j ROUTE --oif eth1
ipt... -i eth0 -m statmux --statmux-size 4 --statmux-way 1 -j ROUTE --oif eth2
ipt... -i eth0 -m statmux --statmux-size 4 --statmux-way 2 -j ROUTE --oif eth3
ipt... -i eth0 -m statmux --statmux-size 4 --statmux-way 3 -j ROUTE --oif eth4

Input for the multiplexing decision is source and destination IP address
of the packet under inspection. Both directions result in the same
choice of way. Distribution should be adequate (jhash_2words(saddr,daddr,0))

Patches both userlevel iptables and kernel, in the obvious ways for a
new match.

There is a patch for 2.4 and one for 2.6, identical at the core.
The 2.6 patch has some bizarre ornaments, to spice it up a bit.

I had the need, so I wrote it. I wouldn't mind if it were put into
patch-o-matic. Any and all comments will be appreciated.

enjoy
  Patrick

--y0ulUmNC+osPPQO6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="pom-statmux.tar.gz"
Content-Transfer-Encoding: base64

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
Zowksqwr1eLR05xsUUaLAiRggIdrRxbU4Wac/PisRFEkkiVbFfeHz070RCoD0X+xRsK6fXfk
WSgCPoIMXLbER2+48jee4BKGzI8k8ZlhYuO8a0Z1eT14RPGJcCgYR43/c/Wuvuxpd87/a3q9
/Xu+/9tod5odkf/XofNfGf9fH5P6X38O4Arv/zYa8v3vjWC2/teXA7hC/l+z05D63wQW6X8d
OYAr5P81m1L/G8Ez9b9SDuDz8/8aWluX8/9NQOb//bUx6f/rzwFcIf+v2ZHz/41guv7XmwO4
yvxf/v23zWCO/teWA/is/L9Om/L/Gh2Z/7kRLKX/F+YArpD/18FlgJz/bQAy/++vjaX8/4U5
QIvyf9ptbRz/mxr6P84EpP9vBDL/R+b/yPwfmf/zx3nFXGb2yMwemdkjM3tkZs+fLuzKnB2Z
syNzdmTOjszZkTk7MmdH5uzInB2ZsyNzdtaes7NOLLX//3M/+iOAK2aALMz/wLL0/e9WQ/z9
L7Ul9/83gUizMC1/ozT+s3zLJYO8U0rRf+1F/zEUFP76XolyiJTSGpJCSi/OCimtJS2ktJa8
kJKgs3pmSOllqSGJ/9NM77VsbOH5v6an//9Tm/K/NF3T5fufG8FJGAxd/2DuWRx5f8gP0Pjv
me16ZGrKN+a53Apc/+kA2GPgG/KcX0JCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJC
QkJCQkJCQkJC4tXxf4ts2cgAoAAA

--y0ulUmNC+osPPQO6--
