From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: RE: Iptables help
Date: Mon, 4 Apr 2005 05:08:40 -0700
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B2729D01@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "dpadalkar2001" <dpadalkar2001@indiatimes.com>,
	<netfilter-devel@lists.netfilter.org>
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

Hi,

I had worked on something similar and could not find any document on
this.

However the rules are stored as "struct ipt_entry" in the kernel. Check
the file ip_tables.c for function do_replace. It should be clearer to
you.=20

If it is not let me know.

Thanks,
Vishwas
-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
dpadalkar2001
Sent: Monday, April 04, 2005 10:42 AM
To: netfilter-devel@lists.netfilter.org
Subject: Iptables help


hello.
    Currently i'm developing something similar to iptables.I wud like to
know
where does the iptables store the rules and the format in which it
sotres the=20
rules. If i can know this , my task to store it in good format becomes a
bit=20
easier and more standardised . I shall be very grateful and am very very
helpful
   thanx
Indiatimes Email now powered by APIC Advantage. Help!=20
Help
