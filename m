From: "Manzoor " <hpmanzoor@rediffmail.com>
Subject: RE: Libipq behaveing abormally!
Date: 10 Dec 2004 10:13:00 -0000
Message-ID: <20041210101300.14116.qmail@webmail32.rediffmail.com>
Reply-To: Manzoor  <hpmanzoor@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
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

  =0AHi,=0AI am a newbee in this field.I am trying to devise a bandwidth ma=
nager in my LAN. I am having three PCs one PC I have made a gateway. Other =
two are connected to it using two interface cards. My program works very we=
ll sometimes and I am able to download big files like 150MB, 200MB at the a=
llocated bandwidth. But when I tried to ping using 10 to 12 terminals takin=
g 1000 bytes packets then suddenly after sometime the program terminates gi=
ving error message "recieved message truncated". If I restart the program t=
hen it again terminates after sometime. What may be the problem? Is it rela=
ted to less memory or what? I am using RedHat Linux 9, kernel version 2.4.x=
x. The algorithm I have used is Token Bucket Algorithm and I am dropping pa=
ckets when there is no token in the bucket. I have used some linked list st=
ructure and file operations in the code that are used in implementing token=
 bucket and to store the IP address and the bandwidth allocated against eac=
h IP. I am giving the sample code below:=0A=0A//---------------------------=
---------------------------------------=0A=0A=0Astatic void die(struct ipq_=
handle *h)=0A{=0A   ipq_perror("bwmanager ");=0A   ipq_destroy_handle(h);=
=0A   exit(1);=0A}=0A=0A=0Aint main(int argc, char * argv[])=0A{=0A int sta=
tus;=0Ainitialize();=0A=0A signal(SIGALRM, sigalarm_handler);=0A alarm(1);=
=0A=0A h =3D ipq_create_handle(0, PF_INET);=0A if (!h)=0A    die(h);=0A    =
                                                                           =
                                              =0A status =3D ipq_set_mode(h=
, IPQ_COPY_PACKET, BUFSIZE);=0A if (status < 0)=0A          die(h);        =
                                                                           =
                                  =0A do{=0A        status =3D ipq_read(h, =
buf, BUFSIZE, 0);=0A        if (status < 0)=0A                   die(h);=0A=
                                                                           =
                                                  =0A        switch (ipq_me=
ssage_type(buf))=0A            {=0A              case NLMSG_ERROR:=0A      =
                         fprintf(stderr, "Received error message %d\n", ipq=
_get_msgerr(buf));=0A                               break;=0A              =
                                                                           =
                                    =0A              case IPQM_PACKET: {=0A=
                                         if(!test())=0A                    =
                     {=0A                                                st=
atus =3D ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);=0A          =
                                      if (status < 0)=0A                   =
                              die(h);=0A                                   =
       }=0A                                  break;=0A                     =
            }=0A                                                           =
                                                                  =0A      =
        default:=0A                                  fprintf(stderr, "Unkno=
wn message type!\n");=0A                                  break;=0A        =
    }=0A   } while (1);=0A                                                 =
                                                                           =
 =0A   ipq_destroy_handle(h);=0A                   return 0;=0A=0A }=0A=0A}=
=0A=0A=0A=0A=0A=0A=0A=0Avoid initialize()=0A{=0A FILE *fp_block, *fp_bwmana=
ger;=0A char ip_addr[16];=0A struct ip_record rec;=0A struct bw_node * bw_t=
emp;=0A                                                                    =
                                                         =0A =0A fp_bwmanag=
er =3D fopen("/etc/bwmanager.conf","rb");=0A if(fp_bwmanager =3D=3D NULL)=
=0A        printf("\nCan not open the bwmanager.conf file\n");=0A else=0A  =
{=0A    while(fread(&rec, sizeof(rec), 1, fp_bwmanager) =3D=3D 1)=0A       =
              bwlist_insert(&bwlist_start, rec);=0A  }=0A fclose(fp_bwmanag=
er);                                                                       =
                                                      =0A                  =
                                                                           =
                                =0A fp_block =3D fopen("/etc/ip_block.conf"=
,"rb");=0A if(fp_block =3D=3D NULL)=0A        printf("\nCan not open the ip=
_block.conf file\n");=0A else=0A  {=0A        while(fread(ip_addr, sizeof(i=
p_addr), 1, fp_block) =3D=3D 1)=0A                blocklist_insert(&blockli=
st_start, ip_addr);=0A  }=0A fclose(fp_block);=0A=0A=0A bw_temp =3D bwlist_=
start;=0A while(bw_temp !=3D NULL)=0A {=0A	tokenlist_insert(&tokenlist_star=
t, bw_temp->ip_rec.IP, bw_temp->ip_rec.upload, bw_temp->ip_rec.download);=
=0A	bw_temp =3D bw_temp->next;=0A }=0A=0A system("modprobe iptable_filter")=
;=0A system("modprobe ip_queue");=0A system("iptables -F");=0A system("ipta=
bles -A INPUT -j QUEUE");=0A system("iptables -A FORWARD -j QUEUE");=0A sys=
tem("iptables -A OUTPUT -j QUEUE");=0A}=0A=0A=0A//This function updates the=
 token bucket after 1 sec=0Avoid sigalarm_handler()=0A{=0A struct token_nod=
e * temp=3Dtokenlist_start;=0A=0A while(temp !=3D NULL)=0A {=0A	if(temp->cu=
rrent_upload_token + temp->upload_token_rate <=3D temp->upload_bucket_size)=
=0A					temp->current_upload_token+=3Dtemp->upload_token_rate;=0A	else=0A		=
temp->current_upload_token =3D temp->upload_bucket_size;=0A=0A=0A        if=
(temp->current_download_token + temp->download_token_rate <=3D temp->downlo=
ad_bucket_size)=0A			                temp->current_download_token+=3Dtemp->=
download_token_rate;=0A        else=0A                temp->current_downloa=
d_token =3D temp->download_bucket_size;=0A=0A=0A	temp =3D temp->next;=0A }=
=0A alarm(1);=0A}=0A=0A=0A=0A=0A=0Aint test()=0A{=0A int status;=0A struct =
token_node *token_temp =3D tokenlist_start;=0A struct block_node *block_tem=
p =3D blocklist_start;=0A m =3D ipq_get_packet(buf);=0A iph =3D (struct iph=
dr *)m->payload;=0A add.s_addr =3D iph->saddr;=0A=0A while(block_temp !=3D =
NULL)=0A {=0A	if(iph->saddr =3D=3D inet_addr(block_temp->IP) || iph->daddr =
=3D=3D inet_addr(block_temp->IP) )=0A           {=0A		status =3D ipq_set_ve=
rdict(h, m->packet_id, NF_DROP, 0, NULL);=0A		if(status < 0)=0A        	 	d=
ie(h);=0A		return 1;=0A	   }=0A=0A	block_temp =3D block_temp->next;=0A }=0A=
=0A while(token_temp !=3D NULL)=0A {=0A	if(iph->saddr =3D=3D inet_addr(toke=
n_temp->IP))=0A	{=0A	     if(m->data_len <=3D token_temp->current_upload_to=
ken)=0A		{=0A			token_temp->current_upload_token-=3Dm->data_len;=0A			statu=
s =3D ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);=0A        		if =
(status < 0)=0A                		die(h);=0A        		return 1;=0A		}=0A	   =
   else=0A		{=0A                        status =3D ipq_set_verdict(h, m->pa=
cket_id, NF_DROP, 0, NULL);=0A                        if (status < 0)=0A   =
                             die(h);=0A                        return 1;=0A=
		}=0A	}=0A=0A=0A	if(iph->daddr =3D=3D inet_addr(token_temp->IP))=0A	{=0A  =
           if(m->data_len <=3D token_temp->current_download_token)=0A      =
          {=0A                        token_temp->current_download_token-=
=3Dm->data_len;=0A                        status =3D ipq_set_verdict(h, m->=
packet_id, NF_ACCEPT, 0, NULL);=0A                        if (status < 0)=
=0A                                die(h);=0A                        return=
 1;=0A                }=0A              else=0A                {=0A        =
                status =3D ipq_set_verdict(h, m->packet_id, NF_DROP, 0, NUL=
L);=0A                        if (status < 0)=0A                           =
     die(h);=0A                        return 1;=0A                }=0A    =
    }=0A=0A=0A 	token_temp =3D token_temp->next;=0A }=0A return 0;=0A      =
                                                                           =
                =0A}=0A=0A=0AWith regards=0D=0A=0D=0A..Manzoor
