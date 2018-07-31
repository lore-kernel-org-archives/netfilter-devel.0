From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/4] treewide: convert ISO_8859-1 text comments to utf-8
Date: Tue, 31 Jul 2018 15:49:20 -0600
Message-ID: <20180731214920.GA20796@rob-hp-laptop>
References: <20180724111600.4158975-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jonathan Cameron <jic23@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-iio@vger.kernel.org,
        linux-pm@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180724111600.4158975-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 24, 2018 at 01:13:25PM +0200, Arnd Bergmann wrote:
> Almost all files in the kernel are either plain text or UTF-8
> encoded. A couple however are ISO_8859-1, usually just a few
> characters in a C comments, for historic reasons.
> 
> This converts them all to UTF-8 for consistency.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../devicetree/bindings/net/nfc/pn544.txt     |   2 +-
>  arch/arm/boot/dts/sun4i-a10-inet97fv2.dts     |   2 +-
>  arch/arm/crypto/sha256_glue.c                 |   2 +-
>  arch/arm/crypto/sha256_neon_glue.c            |   4 +-
>  drivers/crypto/vmx/ghashp8-ppc.pl             |  12 +-
>  drivers/iio/dac/ltc2632.c                     |   2 +-
>  drivers/power/reset/ltc2952-poweroff.c        |   4 +-
>  kernel/events/callchain.c                     |   2 +-
>  net/netfilter/ipvs/Kconfig                    |   8 +-
>  net/netfilter/ipvs/ip_vs_mh.c                 |   4 +-
>  tools/power/cpupower/po/de.po                 |  44 +++----
>  tools/power/cpupower/po/fr.po                 | 120 +++++++++---------
>  12 files changed, 103 insertions(+), 103 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/pn544.txt b/Documentation/devicetree/bindings/net/nfc/pn544.txt
> index 538a86f7b2b0..72593f056b75 100644
> --- a/Documentation/devicetree/bindings/net/nfc/pn544.txt
> +++ b/Documentation/devicetree/bindings/net/nfc/pn544.txt
> @@ -2,7 +2,7 @@
>  
>  Required properties:
>  - compatible: Should be "nxp,pn544-i2c".
> -- clock-frequency: I²C work frequency.
> +- clock-frequency: IÂ²C work frequency.

I'd prefer just plain ASCII 'I2C' here, but either way:

Acked-by: Rob Herring <robh@kernel.org>

Rob
