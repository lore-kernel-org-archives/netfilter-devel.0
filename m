From: netfilter-devel@rtij.nl
Subject: Re: differences between win and unix tcp clients.
Date: Tue, 16 Mar 2004 17:20:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <courier.40572942.00001232@ma.rtij.nl>
References: <024b01c40b4f$e3341620$3f32a8c0@ds.ig.com.br>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <024b01c40b4f$e3341620$3f32a8c0@ds.ig.com.br>
To: "Fabiano Reis" <silos.reis@ig.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Fabiano Reis writes: 

> 
> Conclusion: I think this was because the Windows implementation of TCP=
 detects something different on this connection, maybe it detects in som=
e way that there is a filter on the server side and this is why the time=
 for the error message take so long to appear. 
> 
> Am I right? Is there a workaround for this problem? I need to make win=
dows think that the server is really "down" and that is why i=C2=B4m wri=
tting to you people.

You are right, tcp/ip stacks are different. In this the difference shows=
 
case the filtered port will send back a host-unreachable while the close=
d 
port will send back a TCP-reset. It is best to always send back a TCP re=
set 
when rejecting tcp, all stacks react good to this (they better do, it's =
in 
the RFC). So add a --with-tcp-reset to jour reject and you should be OK.=
 

HTH,
Martijn Lievaart 
