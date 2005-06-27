From: Roberto Nibali <ratz@tac.ch>
Subject: Re: Out-of-Window RST Problem?
Date: Mon, 27 Jun 2005 08:42:08 +0200
Message-ID: <42BF9FC0.2090005@tac.ch>
References: <42BA1649.7020907@variosecure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tim Burress <tim@variosecure.net>
In-Reply-To: <42BA1649.7020907@variosecure.net>
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

> We're using 2.4.30 with TCP window tracking on a box that acts as a
> router, and have been seeing situations where some client systems,
> notably some incarnation of Windows XP SP2 with IE 6.0, are sending RST
> segments with what appear to be incorrect ack sequence numbers. These
> are dropped as out-of-window by Netfilter, with the result that
> connections hang and everybody gets upset. Here is the relevant snippet
> of an example session:
> 
> 1    16:17:06.441369 IP server.1935 > client.48415: P 3465:3931(466) ack
> 3641 win 11680
> 2    16:17:06.597107 IP client.48415 > server.1935: . ack 3931 win 64525
> 3    16:17:10.034881 IP client.48415 > server.1935: P 3641:3683(42) ack
> 3931 win 64525
> 4    16:17:10.035085 IP client.48415 > server.1935: R 3684:3684(0) ack
> 3932 win 1024
> 5    16:17:10.073142 IP server.1935 > client.48415: . ack 3683 win 11680
> 
> So, you can see on line 4 that the ack sequence number in the RST sent
> by the client (caused by a "Stop" click in the browser) has inexplicably
> been incremented from the previous value. For that matter, so has the
> send sequence number, though at least it's in the server's window.

I have similar traces from the wild open world.

> I should say that we have not been able to reproduce this locally, so
> there may well be other factors involved besides the combination of OS
> and browser. Perhaps some update that has not been applied.
> Unfortunately we don't have access to the client system, or even direct
> communication with its owner.

Exactly our problem. It's completely impossible to reproduce it locally, we
don't get access to the customer's broken application, we don't know how to
write such an application and we are only allowed to debug the packet filter
during agreed service windows (through strict SLAs), which we need to upgrade
the rest of the environment.

I'll try to dig up some of the traces since Jozsef Kadlecsik kindly offered to
review the 2.4.x implementation of the tcp window tracking patch.

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
