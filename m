From: Martijn Lievaart <netfilter-devel@rtij.nl>
Subject: Re: 2.6.6-rc3 - "ip_conntrack_in: Frag of proto 17" (udp) with kNFS
 r/wsize > 8192
Date: Fri, 07 May 2004 08:33:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409B2D9D.4000101@rtij.nl>
References: <200405070411.48918.keaafloy@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "=?ISO-8859-15?Q?Kenneth_Aafl=F8y?=" <keaafloy@online.no>
In-Reply-To: <200405070411.48918.keaafloy@online.no>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Kenneth Aafl=F8y wrote:

>Hi!
>
>I hope this problem has not been reported before or that I'm not just p=
icking 
>up on some user-keyboard troubles, I've read over the archives, but cou=
ld not 
>find anything relevat to this issue.
>
>I've come across some strange behavior with a nfs server running on 2.6=
.6-rc3 
>today. My clients is also running this version. Basically when I set th=
e NFS 
>client r/wsize =3D 8192, or remove the connection tracking netfilter mo=
dules 
>the problem goes away. If I set the r/wsize to 16834 and the conntrack =
module 
>is loaded I end up in the code segment below. When this happens the NFS=
 
>client will almost lose connection with the server, and print a lot of;
>NFS server not responding, still trying. NFS server OK.
>  
>

I'm seeing this to on a 2.4.22 kernel. I didn't change anything on the 
r/wsize, so I have the default of 4096, I think. Both have conntrack loa=
ded.

Martijn Lievaart
