From: "Srinivas Krishnan" <shrin_krishnan@yahoo.com>
Subject: Hash Function to Seperate Flows
Date: Tue, 2 May 2006 16:33:15 -0400
Message-ID: <ba7fdfc10605021333i167f9ads7b540a801c349c00@mail.gmail.com>
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

hi,

i am trying to separate different flows, and was wondering if there is
a standard hash function with low collisions i can use to hash based
on src ip, dest ip, src port, dest port and protocol.

there seems to be as hash fn in freeBSD's dummynet code but I do not
know if it can be directly applied, as it does some bit fiddling with
flow_mask.

any help/thoughts would be greatly appreciated

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
