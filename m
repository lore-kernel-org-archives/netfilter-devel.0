From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New standalone nat helper module which help function is never
 called
Date: Thu, 20 Nov 2003 12:51:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201247320.2389-100000@filer.marasystems.com>
References: <20031120105423.27d84443.tuxit@netcourrier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tuXit <tuxit@netcourrier.com>
In-Reply-To: <20031120105423.27d84443.tuxit@netcourrier.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, tuXit wrote:

> 	ascii.tuple.src.ip = 0;
> 	ascii.tuple.src.u.tcp.port = 0;
> 	ascii.tuple.dst.ip = 0;
> 	ascii.tuple.dst.u.tcp.port = __constant_htons(port);
> 	ascii.tuple.dst.protonum = IPPROTO_TCP;
> 	ascii.mask.src.ip = 0;
> 	ascii.mask.src.u.tcp.port = 0xFFFF;
> 	ascii.mask.dst.ip = 0;
> 	ascii.mask.dst.u.tcp.port = 0;
> 	ascii.mask.dst.protonum = 0xFFFF;

The port masks looks a little odd to me.. I think you have got the src/dst 
masks the wrong way around and because of this no sessions will ever match 
your helper registration.

Regards
Henrik
