From: "Thomas T. Soares" <ttsoares@brturbo.com>
Subject: Today CVS and 2.4.19-pre10 issue
Date: 05 Jun 2002 01:27:40 -0300
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023251260.7219.11.camel@dentro>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all... me again  :-(

I am trying to make work H.323...

Today cvs of netfilter and 2.4.19-pre10:

1- kerner sources at /coisas/linux
2- export KERNEL_DIR=/coisas/linux
3- cd /CVSs/netfilter-cvs/userspace
4- ./runme --batch base extra
...
some rejects answered with 'N'
...
5- kernel and modules compiled OK but not installed...
6- ln -s /coisas/linux /usr/src/linux   just to make sure  ;-)
7- at /CVSs/netfilter-cvs/userspace

make

...
cc -O2 -Wall -Wunused -I/coisas/linux/include -Iinclude/
-DIPTABLES_VERSION=\"1.2.7\"  -fPIC -o extensions/libipt_mark_sh.o -c
extensions/libipt_mark.c
extensions/libipt_mark.c: In function `parse':
extensions/libipt_mark.c:67: structure has no member named `bit_op'
extensions/libipt_mark.c:67: `IPT_MARK_BIT_OP_NONE' undeclared (first
use in this function)
extensions/libipt_mark.c:67: (Each undeclared identifier is reported
only once
extensions/libipt_mark.c:67: for each function it appears in.)
extensions/libipt_mark.c:77: structure has no member named `bit_op'
extensions/libipt_mark.c:77: `IPT_MARK_BIT_OP_OR' undeclared (first use
in this function)
extensions/libipt_mark.c:86: structure has no member named `bit_op'
extensions/libipt_mark.c:86: `IPT_MARK_BIT_OP_AND' undeclared (first use
in this function)
extensions/libipt_mark.c: In function `print':
extensions/libipt_mark.c:113: structure has no member named `bit_op'
extensions/libipt_mark.c:113: `IPT_MARK_BIT_OP_AND' undeclared (first
use in this function)
extensions/libipt_mark.c:116: structure has no member named `bit_op'
extensions/libipt_mark.c:116: `IPT_MARK_BIT_OP_OR' undeclared (first use
in this function)
extensions/libipt_mark.c: In function `save':
extensions/libipt_mark.c:131: structure has no member named `bit_op'
extensions/libipt_mark.c:133: `IPT_MARK_BIT_OP_AND' undeclared (first
use in this function)
extensions/libipt_mark.c:135: break statement not within loop or switch
extensions/libipt_mark.c:136: `IPT_MARK_BIT_OP_OR' undeclared (first use
in this function)
extensions/libipt_mark.c:138: break statement not within loop or switch
extensions/libipt_mark.c:139: `IPT_MARK_BIT_OP_NONE' undeclared (first
use in this function)
extensions/libipt_mark.c:141: break statement not within loop or switch
make: *** [extensions/libipt_mark_sh.o] Error 1

What I am doing wrong here...?  :-(

-- 
| Thomas Tschoepke Soares                   |     //   En brujas no
|               ttsoares AT brturbo DOT com |(~~~//'~)    acreo...
|--UIN:961141-------------------------------| \     /  pero que las hay,
| The fact is a secondary aspect of reality |  `\_/'          las hay !
