From: Mikado <mikado4vn@gmail.com>
Subject: Re: How to obtain process ID that created connection or owns one
 packet
Date: Mon, 26 Dec 2005 22:46:52 +0700
Message-ID: <43B0106C.4000205@gmail.com>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>	<43A6EA58.9090201@eurodev.net>
	<43A6EC1F.7030600@eurodev.net>	<43ABED47.8070100@gmail.com>
	<43AC263E.7080508@gmail.com> <43AD5934.3050700@eurodev.net>
Reply-To: mikado4vn@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43AD5934.3050700@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Mikado wrote:
> 
>>Thanks all! Finally I found the answer in 'struct sk_buff':
>>
>>struct sk_buff ( #include <linux/skbuff.h> )
>>|_struct sock ( #include <net/sock.h> )
>>  |_struct socket ( #include <linux/net.h> )
>>    |_struct file ( #include <linux/fs.h> )
>>      |_struct fown_struct ( #include <linux/fs.h> )
>>        |_int pid
> 
> 
> Yes, but AFAIK you can only use that in the OUTPUT hook, not in the
> INPUT path. If my mind serves well, I remember that Patrick McHardy
> posted some patches to add support for socket filtering some time ago. I
> don't know what is the status of such work.
> 

Oh, I'm wrong. Below is definition of 'struct fown_struct':

struct fown_struct {
	rwlock_t lock;          /* protects pid, uid, euid fields */
	int pid;		/* pid or -pgrp where SIGIO should be sent */
	uid_t uid, euid;	/* uid/euid of process setting the owner */
	void *security;
	int signum;		/* posix.1b rt signal to be delivered on IO */
};

'pid' field is not PID of the process created packet. Is there any way
to catch REAL pid from 'struct sk_buff', 'struct sock', 'struct socket',
'struct file'?

Thanks in advanced!
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDsBBsmS/zF9V69ugRAge6AJ9w+KlpK5t8P0sNUBYfLWEn6qU+XwCcDLSt
QH0ZLpwbqKocgGhRbzCQJso=
=mqxD
-----END PGP SIGNATURE-----
