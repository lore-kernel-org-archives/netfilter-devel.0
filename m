From: <Chandra.Vempali@infineon.com>
Subject: Where to mark tc_index field in netfiler code
Date: Fri, 3 Jun 2005 16:39:51 +0530
Message-ID: <04EE7AD0450F7B498BA216312943A1A10276E65D@blrse201.ap.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
content-class: urn:content-classes:message
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

Hi all,

I would like to mark tc_index field of sk_buff with my own value based
on protocol type (tcp, udp, sip etc) and later I want to use it for
specifiying QoS for that packet/connection belonging to specific
protocol.

I believe I can mark this field in Netfilter code in either Connection
tacker code or in protocol specific code,

Can anybody shed some light on this ?

Regards,
Chandra

*Disclaimer*
"This e-mail and any attachments are confidential and may contain trade
secrets or privileged or undisclosed information. They may also be
subject to copyright protection. Please do not copy, distribute or
forward this email to anyone unless authorised. If you are not a named
addressee, you must not use, disclose, retain or reproduce all or any
part of the information contained in this e-mail or any attachments. If
you have received this email by mistake please notify the sender
immediately by return email and destroy/delete all copies of the email."
