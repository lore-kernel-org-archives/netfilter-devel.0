From: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Subject: Re: libipq/payload doubt
Date: Wed, 19 May 2004 08:47:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AB0305.6030406@yahoo.it>
References: <20040519062032.GA32401@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
In-Reply-To: <20040519062032.GA32401@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ulysses Almeida wrote:
  >   I alredy create my first daemon with libipq, I mixed libipq man
> example, intercept.c (from netfilter cvs), and get some ideas from
> tcp_ipv4.c (kernel). This daemon, just look for tcp packges, and print
> some infos on stdout. It's printing IP src and dst address, and now
> i'm trying to print src and dst TCP port address, but, I don't know
> why, when I print those info, I can't get expected ports. port 80 is
> showed as 20480.
> 
>   Do I have to convert something before printing in human readable
> format?
> 

Try to use ---> ntohs(port);

Bye.
