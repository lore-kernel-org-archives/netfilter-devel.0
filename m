From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Wed, 29 Jan 2003 09:09:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030129090945.A880@linux.karinthy.hu>
References: <20030128234654.29362.28104.Mailman@kashyyyk> <15927.22044.618895.821767@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15927.22044.618895.821767@isis.cs3-inc.com>; from don-netf@isis.cs3-inc.com on Tue, Jan 28, 2003 at 08:18:36PM -0800
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Don!

May I ask you to change those u_int8_t's to u_int32_t in 
struct ipt_u32_location_element, struct ipt_u32_value_element,
struct ipt_u32_test, struct ipt_u32?

There's really no point in making those integers 1 byte long when every
second field is (a multiple of) 4 byte long and thus will eventually get
padded during compilation. It just complicates matters.

Thanks,
Laszlo

On Tue, Jan 28, 2003 at 08:18:36PM -0800, Don Cohen wrote:
> +struct ipt_u32_location_element
> +{
> +	u_int32_t number;
> +	u_int8_t nextop;
> +};
> +struct ipt_u32_value_element
> +{
> +	u_int32_t min;
> +	u_int32_t max;
> +};
> +/* *** any way to allow for an arbitrary number of elements?
> +   for now I settle for a limit of 10 of each */
> +#define U32MAXSIZE 10
> +struct ipt_u32_test
> +{
> +	u_int8_t nnums;
> +	struct ipt_u32_location_element location[U32MAXSIZE+1];
> +	u_int8_t nvalues;
> +	struct ipt_u32_value_element value[U32MAXSIZE+1];
> +};
> +
> +struct ipt_u32
> +{
> +	u_int8_t ntests;
> +	struct ipt_u32_test tests[U32MAXSIZE+1];
> +};
