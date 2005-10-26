From: gan hawk <ganhawk@gmail.com>
Subject: Connection tracking and invalid tcp headers
Date: Wed, 26 Oct 2005 14:07:41 -0500
Message-ID: <3305af120510261207t5411203bt86239ef351b844c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hi,

 I would appreciate any responses for this question.

  I have a situation where the ack packet in the tcp handshake will
have wrong seq number. A netfilter module rewrites the right sequence
number for the packet. Hence this has to be before connection
tracking. Is there anyway to detect what connection this packet will
belong to before connection tracking module using some of the data
structures maintained by connection tracking ?
  (If there is no way, I guess I need to maintain a list of packets
for which syn/ack was sent and detect them the acks back as only the
handshake ack will have wrong seq number)

  If the packet with the wrong seq num is passed through any firewall
that forwards it, will it be dropped ?

  Also the first syn packet will not have the ack_seq =3D 0. But I
assume that will not affect the connection tracking in any way. Is
that true ?

  thanks,
  ganesh
