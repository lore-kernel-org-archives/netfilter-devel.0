From: Mikado <mikado4vn@gmail.com>
Subject: Re: How to obtain process ID that created connection or owns one
 packet
Date: Fri, 23 Dec 2005 21:32:48 +0700
Message-ID: <43AC0A90.3000001@gmail.com>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>	<43A6EA58.9090201@eurodev.net>
	<43A6EC1F.7030600@eurodev.net>	<43ABED47.8070100@gmail.com>
	<65aa6af90512230536g6e7eaafaw114038ea31a84e74@mail.gmail.com>
Reply-To: mikado4vn@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Edmundo Carmona <eantoranz@gmail.com>
In-Reply-To: <65aa6af90512230536g6e7eaafaw114038ea31a84e74@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thanks, but I want get it in kernel space. Any ideas?

Edmundo Carmona wrote:
> Processes related to connections can be seen with netstat -p:
> 
> netstat -np
> netstat -nlp
> 
> and so on
> 
> On 12/23/05, Mikado <mikado4vn@gmail.com> wrote:
> 
> Hi,
> 
> I need to know a packet or a connection related to what process ID. In
> Netfilter there is a match called 'owner' but I dont know how it
> actually works. Can somebody tell me these informations?
> 
> Thank you.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDrAqQmS/zF9V69ugRAihMAJ98jsewpBeRvPzPi7iHUhldG2+lTwCdFO52
x+TrWOQiS5A1TTIDDgrxahE=
=qSec
-----END PGP SIGNATURE-----
