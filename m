From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: Problem using REDIRECT and SO_ORIGINAL_DST
Date: Wed, 6 Nov 2002 20:06:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021106190650.GC2985@balabit.hu>
References: <20021106.15222917@w-laptop.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wilson Padovani =?iso-8859-1?Q?J=FAnior?= <admin@netsun.com.br>
Content-Disposition: inline
In-Reply-To: <20021106.15222917@w-laptop.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 06, 2002 at 03:22:29PM +0000, Wilson Padovani Júnior wrote:
> Hi.
> 
>     I trying to write a transparent proxy program, but I having 
> trouble to retrieve the original destination address of the redirected 
> connections.
>         SLen = sizeof(peer);
>         memset(&peer, 0, SLen);
>         getsockopt(new_sock, SOL_IP, SO_ORIGINAL_DST, &peer, &SLen);
>         printf( "Client: %s:%hu\nMe: %s:%hu\nPeer: %s:%hu\n",
>                 inet_ntoa(client.sin_addr), ntohs(client.sin_port),
>                 inet_ntoa(me.sin_addr), ntohs(me.sin_port),
>                 inet_ntoa(peer.sin_addr), ntohs(peer.sin_port) );

inet_ntoa() uses a static buffer to format its result, you are calling
inet_ntoa three times which all work on the same buffer -> the result of the
last invocation will be used three times.

try writing 3 printf() statements, or copy the result of inet_ntoa() to a
private buffer, or create your own inet_ntoa() function.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
