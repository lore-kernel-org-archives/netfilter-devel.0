From: Sven Wandersleb <nibbler@saeuferleber.de>
Subject: bidirectional ip_conntrack_irc
Date: Fri, 30 Dec 2005 18:11:40 +0100
Message-ID: <4dc54d760512300911o5c386f4n76c07d078d5142f8@mail.gmail.com>
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

Hi List,

is there any Plans to get ip_conntrack_irc working in both directions?
Its sad to have connections called NEW, if in fact they are RELATED.

I need it, as i want to catch DCC downloads to mark/route them to a
broader link than the default one.

Greetings
Sven Wandersleb
