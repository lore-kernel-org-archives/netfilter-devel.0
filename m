From: <Atanu.Mondal@infineon.com>
Subject: Calling multiple times ip_nat_mangle_tcp_packet()
Date: Fri, 2 Jul 2004 14:50:35 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <04EE7AD0450F7B498BA216312943A1A1155585@blrse201.ap.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
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
I am mangling SIP Message Header and data and for this I am calling
ip_nat_mangle_tcp_packet() funtion for
each line which need to adjust its IP Address.. The problem I am facing
is with TCP seq numbering..
The ip_nat_resize_packet() function takes care of the seq numbering
inside ip_nat_mangle_tcp_packet() but
it takes care of the adjustment for only the 1st call.. Any subsequent
call to ip_nat_mangle_tcp_packet=20
does not adjust the offset_before and offset_after parameters and the it
remains what it was in the first
call.=20
In the return direction the ack and seq no is adjusted as per the offset
set in the 1st call..which is wrong.

Can somebody help me out in understanding how to do it... Or do I need
to writeout my  own function. ???

Atanu
