From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [new filter] simple packet authentication
Date: Fri, 23 Jan 2004 13:27:40 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231326510.12080-100000@filer.marasystems.com>
References: <0de101c3e147$648fa910$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
In-Reply-To: <0de101c3e147$648fa910$2601010a@bluereef.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Jan 2004, Andrew Hall wrote:

> This is a neat idea although I'd probably be a bit wary to use the IP ID
> field when considering it's use with fragments. Perhaps a better solution
> would be to use part of the options field which apparently DoD originally
> planned to use for this type of IP partitioning. Also it would be good if it
> was payload agnostic (could be used for UDP as well as TCP).

AH comes in mind if you want to support any payload..

Regards
Henrik
