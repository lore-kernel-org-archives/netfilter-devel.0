From: JC <bikkit@gmail.com>
Subject: netfilter hook function error...
Date: Wed, 21 Sep 2005 01:13:43 +0100
Message-ID: <a60102c3050920171352ae872c@mail.gmail.com>
Reply-To: JC <bikkit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

my hook function code, called at :

unsigned int in_hook(unsigned int hooknum,
struct sk_buff **skb,
const struct net_device *in,
const struct net_device *out,
int (*okfn)(struct sk_buff *))
{
  print_string("Packet reached IN_HOOK.");

  struct iphdr *my_ipheader;
  //u32 this_address;

  if (out)
    {
      if(out->name)
=09{
=09  print_string("out is: ");
=09  print_string(out->name);


=09  // compare the out device with the list of rules
=09  // TODO: replace by matches_rule()
=09  if (strcmp(out->name, "eth1") =3D=3D 0)
=09    {

=09      print_string("packet matches rule");


=09      if(skb =3D=3D NULL)
=09=09{
=09=09  return -1;
=09=09}
=09
=09      my_ipheader =3D skb->nh->iph;
=09      print_string("printk-ing saddr...");
=09      //this_address =3D *my_ipheader->saddr;
=09      //printk("the ip is : %d.%d.%d.%d\n",NIPQUAD(*my_ipheader->saddr))=
;

=09    }
=09}
      else
=09{
=09  print_string("out is null");
=09}
    }


  return NF_QUEUE;           /* Drop ALL packets */
}


line 150 is =09      my_ipheader =3D skb->nh->iph;

on compile, I get this error:

[root@whatever spider]# make -C /usr/src/kernels/`uname -r`-i686
SUBDIRS=3D$PWD modules
make: Entering directory `/usr/src/kernels/2.6.12-1.1447_FC4-i686'
  CC [M]  /home/jc/code/spider/spider.o
/home/jc/code/spider/spider.c: In function 'in_hook':
/home/jc/code/spider/spider.c:126: warning: ISO C90 forbids mixed
declarations and code
/home/jc/code/spider/spider.c:134: warning: passing argument 1 of
'print_string' discards qualifiers from pointer target type
/home/jc/code/spider/spider.c:150: error: request for member 'nh' in
something not a structure or union


I've seen that statement being made more than a number of times, so
what am I doing wrong??

I need to change the saddr (source address) in that if to another one
(basicly, NATing it). How will I commit that change to the skb and
then send it back into the stack?

thanx in advance...

John
