From: "Saber zrelli" <saber_z@fastmail.fm>
Subject: Re: real time stateful filtering question
Date: Wed, 17 Mar 2004 16:49:37 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079509777.8006.182822495@webmail.messagingengine.com>
References: <Pine.LNX.4.44.0403170807250.4188-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Community" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: "peter smith" <smith-peter@comcast.net>
In-Reply-To: <Pine.LNX.4.44.0403170807250.4188-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Wed, 17 Mar 2004 08:13:43 +0100 (CET), "Henrik Nordstrom"
<hno@marasystems.com> said:
> On Mon, 15 Mar 2004, peter smith wrote:
> 
> > Unfortunately, packets sent on the data channel are also in your receive
> > buffer, and get processed by netfilter *before* the "PORT COMMAND" packet
> > gets processed by the userland monitor, or before the monitor can
> > sucessfully re-program the netfilter filter list. So they are dropped,
> > silently.
> 
> This is a somewhat bad example as FTP does not do anything with the data 
> channel until a response to the PORT command is seen and thus there can 
> not be such race window there.
> 
> For most other protocols with "related" channels the same criteria is
> also
> true. But there probably is some protocols not waiting for a response to
> their control message before starting to use the "related" channel and
> where the race you discuss can occur.
> 
> You can minimize the race by running your session tracking in the kernel 
> as conntrack protocol helpers, but even then there will be a small race 
> window if the appliaction does not wait for some response to the control 
> message before starting to use the related connection.

if there is a kernel module that does the filtering , why does race still
exist ,
if the filtering is programatically set then no packet will be proceeded
until your return from the hook function .
thats why it is called interruption also .


Regards.
-- 
  Saber Zrelli
  kanazawa university international house 
  kakuma-machi , kanazawa , Ishikawa 
  920-1192 Japan. 
