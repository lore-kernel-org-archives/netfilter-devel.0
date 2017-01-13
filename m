From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v3 1/8] arm: put types.h in uapi
Date: Fri, 13 Jan 2017 17:01:01 +0100
Message-ID: <4633e475-47f2-5627-81a9-a1747dfddbc0@6wind.com>
References: <1484304406-10820-2-git-send-email-nicolas.dichtel@6wind.com>
 <3131144.4Ej3KFWRbz@wuerfel>
 <1484304406-10820-1-git-send-email-nicolas.dichtel@6wind.com>
 <25063.1484321803@warthog.procyon.org.uk>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: arnd@arndb.de, linux-mips@linux-mips.org,
        linux-m68k@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-doc@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-mtd@lists.infradead.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-am33-list@redhat.com,
        linux-c6x-dev@linux-c6x.org, linux-rdma@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-sh@vger.kernel.org,
        linux@armlinux.org.uk, coreteam@netfilter.org,
        fcoe-devel@open-fcoe.org, xen-devel@lists.xenproject.org,
        linux-snps-arc@lists.infradead.org, linux-media@vger.kernel.org,
        uclinux-h8-devel@lists.sourceforge.jp,
        linux-xtensa@linux-xtensa.org, linux-kbuild@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-raid@vger.kernel.org,
To: David Howells <dhowells@redhat.com>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <25063.1484321803@warthog.procyon.org.uk>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: netfilter-devel.vger.kernel.org

Please, do not remove the email subject when you reply. I restore it to ease the
thread follow-up.

Le 13/01/2017 à 16:36, David Howells a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> 
>> This header file is exported, thus move it to uapi.
> 
> Exported how?
It is listed in include/uapi/asm-generic/Kbuild.asm, which is included by
arch/arm/include/uapi/asm/Kbuild.

You can also have a look at patch #5 to see why it was exported even if it was
not in an uapi directory.

Regards,
Nicolas
