From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: argv[optind-1] == optarg
Date: Tue, 25 May 2004 21:24:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405252123140.17545-100000@filer.marasystems.com>
References: <40AF9F99.7070305@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur Akan <akan@aiqa.com>
In-Reply-To: <40AF9F99.7070305@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 22 May 2004, Ozgur Akan wrote:

> I think using optarg instead of argv[optind-1] will be better. In 
> iptables.c; while parsing iptables options with getopt_long, 
> argv[optind-1] is used in 8 places.

If I recall correectly the reason why it is done the way it is is the
processing of ! (not).


  ! -d a.b.c.d
  -d ! a.b.c.d

Regards
Henrik
