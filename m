From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: ipt_entry
Date: Sun, 27 Mar 2005 21:34:51 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B26A2BB6@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Hi IPTables-gurus,

I need some help. Could someone tell me the exact nature of structure
that is passed from the user space to the kernel space, when a rule is
programmed?

I know we look at ipt_entry structure, but that does not have all the
extended information besides it does not have the ipt_target
information. Could someone please tell me or point me to a document
which tells the exact nesting of structures that are passed between user
and the kernel? I want to parse the fields in the structure in the
kernel.

Thanks,
Vishwas
