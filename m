From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Wed, 29 Jan 2003 07:28:57 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15927.62265.746506.765623@isis.cs3-inc.com>
References: <20030128234654.29362.28104.Mailman@kashyyyk>
	<15927.22044.618895.821767@isis.cs3-inc.com>
	<20030129090945.A880@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
In-Reply-To: <20030129090945.A880@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Laszlo Valko writes:
 > Hi Don!
 > 
 > May I ask you to change those u_int8_t's to u_int32_t in 
 > struct ipt_u32_location_element, struct ipt_u32_value_element,
 > struct ipt_u32_test, struct ipt_u32?
 > 
 > There's really no point in making those integers 1 byte long when every
 > second field is (a multiple of) 4 byte long and thus will eventually get
 > padded during compilation. It just complicates matters.

Now that I've dumped it in Harald's lap I guess it's up to him.
But I don't see how it complicates matters.

 > > +struct ipt_u32_test
 > > +{
 > > +	u_int8_t nnums;
 > > +	struct ipt_u32_location_element location[U32MAXSIZE+1];
 > > +	u_int8_t nvalues;
 > > +	struct ipt_u32_value_element value[U32MAXSIZE+1];
 > > +};

In this one case at least it might help to put the two 8's together,
right? 
