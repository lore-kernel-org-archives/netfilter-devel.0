From: "Srinivas Krishnan" <shrin_krishnan@yahoo.com>
Subject: Extracting port numbers
Date: Tue, 2 May 2006 16:25:37 -0400
Message-ID: <ba7fdfc10605021325o39c09204r798e385b75e6b5bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I was trying to extract tcp port numbers from sk_buff, going through
netfilter code, there seem multiple ways of doing it. I was wondering
if there is one standard way to do it which is generic enough to fit
any situation.

For seem reason the
struct tcphrd *tcp =3D (struct tcphrd *)(skb->data + (skb->nh.iph->ihl*4));

dest_port =3D tcp->dest;

does not work and extracts wrong port numbers.

-srinivas

--
*********************************
Srinivas Krishnan

Graduate Student
Dept. Of Computer Science
UNC-Chapel Hill
++++++++++++++++++++++++++++++++
 Phone:
   **Office: (919) 962-1920
   **Cell:    (585)295-3359
 Email: krishnan@cs.unc.edu, shrin.krishnan@gmail.com
++++++++++++++++++++++++
 Web: www.cs.unc.edu/~krishnan
 **************************************
