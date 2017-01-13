From: David Howells <dhowells@redhat.com>
Subject: (unknown)
Date: Fri, 13 Jan 2017 15:36:43 +0000
Message-ID: <25063.1484321803@warthog.procyon.org.uk>
References: <1484304406-10820-2-git-send-email-nicolas.dichtel@6wind.com> <3131144.4Ej3KFWRbz@wuerfel> <1484304406-10820-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, arnd@arndb.de, linux-mips@linux-mips.org,
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
        linux-
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1484304406-10820-2-git-send-email-nicolas.dichtel@6wind.com>
Content-ID: <25062.1484321803.1@warthog.procyon.org.uk>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> This header file is exported, thus move it to uapi.

Exported how?

> +#ifdef __INT32_TYPE__
> +#undef __INT32_TYPE__
> +#define __INT32_TYPE__		int
> +#endif
> +
> +#ifdef __UINT32_TYPE__
> +#undef __UINT32_TYPE__
> +#define __UINT32_TYPE__	unsigned int
> +#endif
> +
> +#ifdef __UINTPTR_TYPE__
> +#undef __UINTPTR_TYPE__
> +#define __UINTPTR_TYPE__	unsigned long
> +#endif

These weren't defined by the kernel before, so why do we need to define them
now?

Will defining __UINTPTR_TYPE__ cause problems in compiling libboost by
changing the signature on C++ functions that use uintptr_t?

David
