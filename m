From: <Atanu.Mondal@infineon.com>
Subject: Expectation is not getting changed to conntrack
Date: Mon, 6 Sep 2004 13:48:25 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <04EE7AD0450F7B498BA216312943A1A11555E8@blrse201.ap.infineon.com>
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi All,

I have a following situation where for the SIP INVITE (with sdp data )
message I am building an expectation for messages with dst ip and dst
port. On receiving a 200 OK message(with sdp data) from the other side I
am building another expectation with dst ip and dst port on the opposite
direction. Now when my first expectation gets hit with a RTP packet with
the dst ip and dst port its gets changed to conntrack and is allowed.
But when on the opposite direction another RTP packet comes with the dst
ip and dst port of the second expectation, that expectation doesn't
changes to conntrack and the packet gets dropped. The situation gets
like one way the voice call is through and the other side it is blocked.
Does anyone have any idea what can be the reason ?



                           exp  0:0->B:b
                           exp  0:0->A:a'

phoneA                   Firewall                phoneB

ip A, port a-------------------RTP-------------->ip B, port b

ip A, port a' <--XXXXXXXXRTP dropped--  ip B, port b'

Regards
Atanu Mondal

*Disclaimer*
"This e-mail and any attachments are confidential and may contain trade
secrets or privileged or undisclosed information. They may also be
subject to copyright protection. Please do not copy, distribute or
forward this email to anyone unless authorized. If you are not a named
addressee, you must not use, disclose, retain or reproduce all or any
part of the information contained in this e-mail or any attachments. If
you have received this email by mistake please notify the sender
immediately by return email and destroy/delete all copies of the email."
