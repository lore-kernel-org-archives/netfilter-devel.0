From: "Mohammed Awad" <MAwad@Enppi.com>
Subject: rowsocket or setsocketopt
Date: Mon, 30 Jun 2003 15:25:29 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5B329B5DBE10D943868D0D15E26BBED422C2CE@ntserver.enppi-mail.corp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1256"
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

High all,
What I need to do is develop a TARGET that inserts a new type of ip =
option in the trapped packets. I did some trivial examination with  the =
setsockopt,, but I understood that it deals with only standard IP =
options, (e.g timestamp, loose source, .....). Then, my question is =
just:
1- Can I somehow insert the new type IP option using the setsockopt,? or
2- I should use some other system call, like (row socket for example)?
Thanks all
