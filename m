From: Patrick Schaaf <bof@bof.de>
Subject: Re: Netfilter and IPPROTO_RAW
Date: Sun, 24 Nov 2002 10:55:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021124095510.GB14672@oknodo.bof.de>
References: <00ba01c28ffe$3bc9a0d0$6a00a8c0@witbe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Rolland <rol@as2917.net>
Content-Disposition: inline
In-Reply-To: <00ba01c28ffe$3bc9a0d0$6a00a8c0@witbe>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> My problem is that one of the program we are using is sending
> its packets to a socket that has been created by :
> theSocket = socket(PF_INET, SOCK_RAW, IPPROTO_RAW);
> and it seems from all the tests I've conducted that these packets
> are bypassing all the rules aboved mentionned...

Correct, as far as I know. Using RAW sockets is not "normal".
iptables caters to what "normal" usage needs. And that's basically
a good thing.

> Is there a way to interact on packets sent to such a socket ?

Change the app, or give it an LD_PRELOAD library overwriting
the recvmsg/sendmsg calls, or change the kernel so RAW sockets
have netfilter hooks. Those are your possibilities. Good luck.

best regards
  Patrick
