From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: why I cann't compile the program?
Date: Tue, 25 Nov 2003 08:01:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC2FE31.50305@gmx.de>
References: <E1AOSBp-0003rO-Sc@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <E1AOSBp-0003rO-Sc@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,


Fangweiwei wrote:

>----------------------------------------------
>I try to compile it using: gcc test.c 
>  
>
try compiling it with

gcc -o test test.c -lipq

This will link it with the ipq library (which you of course must have
installed).

>but it gives me some msg as following:
>
>/tmp/ccYcdyBh.o: In function `die':
>/tmp/ccYcdyBh.o(.text+0xf): undefined reference to `ipq_perror'
>/tmp/ccYcdyBh.o(.text+0x1d): undefined reference to `ipq_destroy_handle'
>/tmp/ccYcdyBh.o: In function `main':
>/tmp/ccYcdyBh.o(.text+0x41): undefined reference to `ipq_create_handle'
>/tmp/ccYcdyBh.o(.text+0x7b): undefined reference to `ipq_set_mode'
>/tmp/ccYcdyBh.o(.text+0xb5): undefined reference to `ipq_read'
>/tmp/ccYcdyBh.o(.text+0xe3): undefined reference to `ipq_message_type'
>/tmp/ccYcdyBh.o(.text+0x12a): undefined reference to `ipq_get_msgerr'
>/tmp/ccYcdyBh.o(.text+0x157): undefined reference to `ipq_get_packet'
>/tmp/ccYcdyBh.o(.text+0x17e): undefined reference to `ipq_set_verdict'
>collect2: ld returned 1 exit status
>
>----------------------------------------------
>
>can you help me? thanks a lot.
>
>　　　　　　　　Fangweiwei
>　　　　　　　　fangweiwei@tom.com
>　　　　　　　　　　2003-11-25
>

Sven
