From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] treewide: convert ISO_8859-1 text comments to utf-8
Date: Wed, 25 Jul 2018 15:12:11 +0200
Message-ID: <CAK8P3a3tOuP1FVS7oD1UhO5s4C+fLkL8VT3eCpRnSxBZxKzf6A@mail.gmail.com>
References: <20180724111600.4158975-1-arnd@arndb.de> <20180724140010.e24a9964fd340afe2d98a994@linux-foundation.org>
 <aa39b6d15f44555cb79d5ebdef74aeab19003d6a.camel@perches.com> <20180724175531.75276cf4e539124aa9e27177@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Joe Perches <joe@perches.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jonathan Cameron <jic23@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-iio@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180724175531.75276cf4e539124aa9e27177@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

tools/perf/tests/.gitignore:
                            LLVM byte-codes, uncompressed
On Wed, Jul 25, 2018 at 2:55 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 24 Jul 2018 17:13:20 -0700 Joe Perches <joe@perches.com> wrote:
>
>> On Tue, 2018-07-24 at 14:00 -0700, Andrew Morton wrote:
>> > On Tue, 24 Jul 2018 13:13:25 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>> > > Almost all files in the kernel are either plain text or UTF-8
>> > > encoded. A couple however are ISO_8859-1, usually just a few
>> > > characters in a C comments, for historic reasons.
>> > > This converts them all to UTF-8 for consistency.
>> []
>> > Will we be getting a checkpatch rule to keep things this way?
>>
>> How would that be done?
>
> I'm using this, seems to work.
>
>         if ! file $p | grep -q -P ", ASCII text|, UTF-8 Unicode text"
>         then
>                 echo $p: weird charset
>         fi

There are a couple of files that my version of 'find' incorrectly identified as
something completely different, like:

Documentation/devicetree/bindings/pinctrl/pinctrl-sx150x.txt:
            SemOne archive data
Documentation/devicetree/bindings/rtc/epson,rtc7301.txt:
            Microsoft Document Imaging Format
Documentation/filesystems/nfs/pnfs-block-server.txt:
            PPMN archive data
arch/arm/boot/dts/bcm283x-rpi-usb-host.dtsi:
        Sendmail frozen configuration  - version = "host";
Documentation/networking/segmentation-offloads.txt:
        StuffIt Deluxe Segment (data) : gmentation Offloads in the
Linux Networking Stack
arch/sparc/include/asm/visasm.h:                              SAS 7+
arch/xtensa/kernel/setup.c:                                         ,
init=0x454c, stat=0x090a, dev=0x2009, bas=0x2020
drivers/cpufreq/powernow-k8.c:
TI-XX Graphing Calculator (FLASH)
tools/testing/selftests/net/forwarding/tc_shblocks.sh:
                            Minix filesystem, V2 (big endian)
tools/perf/tests/.gitignore:
                            LLVM byte-codes, uncompressed

All of the above seem to be valid ASCII or UTF-8 files, so the check
above will lead
to false-positives, but it may be good enough as they are the
exception, and may be
bugs in 'file'.

Not sure if we need to worry about 'file' not being installed.

       Arnd
