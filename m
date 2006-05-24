From: Patrick Schaaf <bof@bof.de>
Subject: Re: New extension: CRYPT target
Date: Wed, 24 May 2006 07:03:05 +0200
Message-ID: <20060524050305.GB20541@oknodo.bof.de>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<"4470D859.7000706"@speedy.com.ar> <4470E716.1090001@gmx.net>
	<4473380F.5050102@speedy.com.ar> <44733C72.1020008@gmx.net>
	<44734149.2040900@trash.net> <447342F4.2010405@gmx.net>
	<4473970A.9050008@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Content-Disposition: inline
In-Reply-To: <4473970A.9050008@speedy.com.ar>
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

> The idea of using a file is like this:
> 1- Being root, create a file called /root/file1.key
> #touch /root/file1.key
> #ls -al /root/file1.key
> -rw-r--r--  1 root root 0 May 23 20:05 file1.key

Now the attacker can open the file (if they have permission to read
that directory, but I'm sure you didn't want to know that...)

> 2- Change permissions
> #chmod 600 /root/file1.key
> #ls -al /root/file1.key
> -rw-------  1 root root 0 May 23 20:05 file1.key

The attacker keeps the file open; this does not change anything.

> 3- Open /root/file1.key and add a key

And now the attacker can read the key from the still open file.

You should try to understand what people here are telling you.

best regards
  Patrick
