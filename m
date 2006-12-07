From: Krzysztof Oledzki <ole@ans.pl>
Subject: ipset: Save operation failed, try again later
Date: Thu, 7 Dec 2006 20:19:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612071955540.21578@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-932154933-1165519171=:21578"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-932154933-1165519171=:21578
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

It seems that "ipset -S setname" is not able to work when there is 60 or=20
more sets:

---cut here ---
#!/bin/sh

cnt=3D0;

ipset=3D"/tmp/ipset-2.2.9a/ipset"

ipset -F
ipset -X

while true ; do
   echo $((cnt++))
   $ipset -N R$cnt nethash --hashsize 1024 --probes 4 --resize 50
   $ipset -S R$cnt >/dev/null || exit
done
---cut here ---

1
(...)
60
ipset v2.2.9a: Save operation failed, try again later.


I added some debuging code, with 59 sets I get:
(...)
ipset.c: settype_find (DBG): nethash
ipset.c: load_set_list (DBG): loaded R60, type nethash, index 59
ipset.c: wrapped_getsockopt (DBG): res=3D0 errno=3D0
ipset.c: try_save_sets (DBG): size: 0, req_size: 4128
ipset.c: save_set (DBG): offset 0, len 4128
ipset.c: save_set (DBG): offset =3D 0
ipset.c: save_set (DBG): sizeof(struct ip_set_save) =3D 12
ipset.c: save_set (DBG): len =3D 4128
ipset.c: save_set (DBG): set_save->header_size =3D 8
ipset.c: save_set (DBG): set_save->members_size =3D 4096
ipset.c: try_save_sets (DBG): size: 4116, req_size: 4128
ipset.c: save_set (DBG): offset 4116, len 4128
ipset.c: save_set (DBG): offset =3D 4116
ipset.c: save_set (DBG): sizeof(struct ip_set_save) =3D 12
ipset.c: save_set (DBG): len =3D 4128
ipset.c: save_set (DBG): set_save->header_size =3D 0
ipset.c: save_set (DBG): set_save->members_size =3D 0
ipset.c: save_default_bindings (DBG): R60, binding 65535

With 60:
(...)
ipset.c: load_set_list (DBG): loaded R58, type nethash, index 57
ipset.c: settype_find (DBG): nethash
ipset.c: load_set_list (DBG): loaded R59, type nethash, index 58
ipset.c: settype_find (DBG): nethash
ipset.c: load_set_list (DBG): loaded R60, type nethash, index 59
ipset.c: settype_find (DBG): nethash
ipset.c: load_set_list (DBG): loaded R61, type nethash, index 60
ipset.c: wrapped_getsockopt (DBG): res=3D0 errno=3D0
ipset.c: try_save_sets (DBG): size: 0, req_size: 4128
ipset.c: save_set (DBG): offset 0, len 4128
ipset.c: save_set (DBG): offset =3D 0
ipset.c: save_set (DBG): sizeof(struct ip_set_save) =3D 12
ipset.c: save_set (DBG): len =3D 4128
ipset.c: save_set (DBG): set_save->header_size =3D 8
ipset.c: save_set (DBG): set_save->members_size =3D 4096
ipset.c: try_save_sets (DBG): size: 4116, req_size: 4128
ipset.c: save_set (DBG): offset 4116, len 4128
ipset.c: save_set (DBG): offset =3D 4116
ipset.c: save_set (DBG): sizeof(struct ip_set_save) =3D 12
ipset.c: save_set (DBG): len =3D 4128
ipset.c: save_set (DBG): set_save->header_size =3D 0
ipset.c: save_set (DBG): set_save->members_size =3D 1752458606
ipset v2.2.9a: Save operation failed, try again later.

Please notice very big number in set_save->members_size: before (59 sets)=
=20
it was 4096 and now (60 sets) it is 1752458606. Memory corruption maybe?


# zcat /proc/config.gz|grep NF_SET
CONFIG_IP_NF_SET=3Dy
CONFIG_IP_NF_SET_MAX=3D256
CONFIG_IP_NF_SET_HASHSIZE=3D1024
CONFIG_IP_NF_SET_IPMAP=3Dy
CONFIG_IP_NF_SET_MACIPMAP=3Dy
CONFIG_IP_NF_SET_PORTMAP=3Dy
CONFIG_IP_NF_SET_IPHASH=3Dy
CONFIG_IP_NF_SET_NETHASH=3Dy
CONFIG_IP_NF_SET_IPPORTHASH=3Dy
CONFIG_IP_NF_SET_IPTREE=3Dy

Tested with both 2.6.16 and 2.6.18.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-932154933-1165519171=:21578--
