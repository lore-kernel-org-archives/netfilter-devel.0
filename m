From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: del_timer[_sync]
Date: Wed, 22 Sep 2004 07:41:02 -0400
Sender: netfilter-bounces@lists.netfilter.org
Message-ID: <876ef97a04092204415fb5f672@mail.gmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-bounces@lists.netfilter.org>
To: linux-net <linux-net@vger.kernel.org>,
	netfilter <netfilter@lists.netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I have a timer that fires every $X seconds while the module is loaded.
I want to stop and remove the timer upon module unload. What is the
proper way to accomplish this?

In the module's __exit function, I am using this code to remove the timer:

[...]
del_timer_sync( &timer);
if (timer_pending( &timer))
=A0 =A0 =A0 =A0del_timer( &timer);
[...]

Is this the right way, or unnecessary overkill? I've seen multiple
ideas on how best to properly remove a timer. Thanks in advance! :)

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
