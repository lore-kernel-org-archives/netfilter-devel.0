From: Mikado <mikado4vn@gmail.com>
Subject: Re: How to obtain process ID that created connection or owns one
 packet
Date: Fri, 23 Dec 2005 23:30:54 +0700
Message-ID: <43AC263E.7080508@gmail.com>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>
	<43A6EA58.9090201@eurodev.net> <43A6EC1F.7030600@eurodev.net>
	<43ABED47.8070100@gmail.com>
Reply-To: mikado4vn@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  netfilter@lists.netfilter.org
In-Reply-To: <43ABED47.8070100@gmail.com>
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

Thanks all! Finally I found the answer in 'struct sk_buff':

struct sk_buff ( #include <linux/skbuff.h> )
|_struct sock ( #include <net/sock.h> )
  |_struct socket ( #include <linux/net.h> )
    |_struct file ( #include <linux/fs.h> )
      |_struct fown_struct ( #include <linux/fs.h> )
        |_int pid

Bye.

Mikado wrote:
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

iD8DBQFDrCY+mS/zF9V69ugRAobiAJ9lv0ohom3ALFrDM0Thcuq3xI8RbACfZ6Fp
eLnw35D1WRgJkA19nh77GsA=
=wKst
-----END PGP SIGNATURE-----
