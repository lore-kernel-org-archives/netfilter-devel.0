From: Matt Skidmore <fox@woozle.org>
Subject: Re: Feasability of Protocol Filtering
Date: Fri, 25 Apr 2003 17:10:11 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44+maildir.0304251706240.12449-100000@woozle.org>
References: <200304260041.h3Q0fNr20483@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200304260041.h3Q0fNr20483@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> But wouldn't this be resolved by only doing a single pass through of
> the detection code, per stream/conntrack?  Ie;  if the ftp data is related
> to an existing ftp stream, then it won't have a detection attempt made
> on it by the proto_detect module ... surely ...

excellent point! once the connection has been completed and it has
"passed" our inspection we no longer need to examine addtional packets
from that connection. with will surely resolve and aleviate our cpu usage
problems greatly. its still not a bad idea to tell it to look for string
matching starting at a certain byte. that is, if it doesnt vary too much.

-matt
