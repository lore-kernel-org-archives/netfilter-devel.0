From: Fabrice MARIE <fabrice@celestix.com>
Subject: Re: Today CVS and 2.4.19-pre10 issue
Date: Wed, 5 Jun 2002 14:54:56 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206051454.56520.fabrice@celestix.com>
References: <1023251260.7219.11.camel@dentro>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Thomas T. Soares" <ttsoares@brturbo.com>,
	netfilter-devel@lists.samba.org
In-Reply-To: <1023251260.7219.11.camel@dentro>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

On Wednesday 05 June 2002 12:27, Thomas T. Soares wrote:
> Hi all... me again  :-(
> I am trying to make work H.323...
> 4- ./runme --batch base extra
> cc -O2 -Wall -Wunused -I/coisas/linux/include -Iinclude/
> -DIPTABLES_VERSION=\"1.2.7\"  -fPIC -o extensions/libipt_mark_sh.o -c
> extensions/libipt_mark.c
> extensions/libipt_mark.c: In function `parse':
> extensions/libipt_mark.c:67: structure has no member named `bit_op'
> extensions/libipt_mark.c:67: `IPT_MARK_BIT_OP_NONE' undeclared (first
> use in this function)
> extensions/libipt_mark.c:67: (Each undeclared identifier is reported
> only once
> [etc...]
> What I am doing wrong here...?  :-(

Seems like the patch extra/mark-bitwise-ops got applied only half way: the userspace part only
and not the kernel header part (which would be quite unlikely).
Can you check that the file /usr/include/linux points to /usr/src/linux/include/linux ? :
# ls -dl /usr/include/linux
lrwxrwxrwx    1 root     root           28 May 16 16:27 /usr/include/linux -> /usr/src/linux/include/linux/
If it doesn't, then make it point to it.
That's all I can think of. I've just tried, to apply the patches like you did,
with pre10 and the latest netfilter cvs snapshot and libipt_mark compiles fine :

...
cc -O2 -Wall -Wunused -I/usr/src/linux//include -Iinclude/
  -DIPTABLES_VERSION=\"1.2.7\"  -fPIC -o extensions/libipt_mark_sh.o
  -c extensions/libipt_mark.c
ld -shared -o extensions/libipt_mark.so extensions/libipt_mark_sh.o
...

Have a nice day,

Fabrice.
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators" 
       -Unknown
