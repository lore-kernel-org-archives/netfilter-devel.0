From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Illegal option `-i' with conntrack -I
Date: Thu, 3 Nov 2005 14:36:14 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511031427190.1341@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1793583010-1131024974=:1341"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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

---187430788-1793583010-1131024974=:1341
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

It seems it is not possible to specify conntrack id while adding new=20
conntrack. Is it intentionally?

# conntrack -I --orig-src 1.2.3.4 --orig-dst 1.2.3.5 --reply-src 2.3.4.5 --=
reply-dst 2.3.4.5 -p tcp --orig-port-src 1 --orig-port-dst 2 --reply-port-s=
rc 3 --reply-port-dst 5 -t 32323 -u ASSURED -i 99
conntrack v0.95: Illegal option `-i' with this command
Try `conntrack -h' or 'conntrack --help' for more information.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1793583010-1131024974=:1341--
