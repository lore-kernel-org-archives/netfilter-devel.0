From: "PAUL FABRICIO VILLACRESES LEON" <paulvillacreses@hotmail.com>
Subject: Questions about libiptc.a with DNAT ,SNAT and REDIRECT
Date: Thu, 16 Jan 2003 22:25:09 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F60yCF1HkikieqXItMc00026c7e@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org





Hi

iptables's Developers

I'm Paul Villacreses
Student ESPOL ECUADOR
TOPIC : Firewall content

I had develop a program with libiptc.a and othes library libpcap, i had the 
following

|Internel |--------eth0 -------- Myfirewall ------ eth1 ------|LAN 
protected|

In Myfirewall program puts rules in the chain FORWARD with this function
the following code work well .

////////////////////////////IPTABLES////////////////////////////////////////////////////////
int SetNuevaRegla(register const u_char *cp,char *stable,char *starget,char 
*schain)
{
  register const struct ip *ip;
  iptc_handle_t handle = NULL;
  struct ipt_entry *chain_entry;
	ipt_chainlabel labelit;
  long result = 0,size=0;


  ip = (const struct ip *)cp;
  //printf("Size of standard target: %d\n", sizeof(target));
  chain_entry = NULL;
  // the target of this rule is QUEUE
  strncpy(&target.target.u.user.name[0], starget, 30);  // other std rules 
would include DROP etc
  // set the target size!!
  target.target.u.user.target_size=sizeof(target);
  chain_entry = malloc(sizeof(struct ipt_entry) + sizeof(target));
  memset(chain_entry, 0, sizeof(chain_entry));  // zero it out

if(ip->ip_dst.s_addr && ip->ip_src.s_addr)
{
  chain_entry->ip.src.s_addr=ip->ip_src.s_addr;   // src address
  chain_entry->ip.smsk.s_addr=-1;   // mask

  chain_entry->ip.dst.s_addr=ip->ip_dst.s_addr;   // dst address
  chain_entry->ip.dmsk.s_addr=-1;   // mask
  chain_entry->ip.proto=ip->ip_p; // any protocol ip
// chain_entry->
  if(!GetExisteRegla(chain_entry,stable,starget,schain))
  {
     // assuming matches do not need to be taken into account, as we are 
matching everything!
    size=sizeof(struct ipt_entry);
  //  printf("sizeof chain_target_offset: %d\n", size);
    chain_entry->target_offset=size;
    chain_entry->next_offset= size + sizeof(target);    // next target is 
the next rule (offset is size of current entry)
  //  printf("value of chain entry next offset: %d\n", 
chain_entry->next_offset);
    memcpy(chain_entry->elems,&target, sizeof(target));
    // standard is the name given to any of the system defined targets, like 
DROP, ACCEPT, REJECT, QUEUE, RETURN
    handle = iptc_init(stable);    // check if table is loaded
    if (handle == NULL)
    {
    printf("Error en Crear Regla : Table not loaded!\n");
    exit(0);
    }
    result = iptc_is_chain(schain, handle);
    if(!result)
      printf("Error en Crear Regla: Chain does not exist!\n");

    // set the name of the chain we want to append to
    strncpy(labelit,schain, 30);

      result = iptc_append_entry(labelit,chain_entry, &handle);
      if(result == 0)
        printf("Append error en Crear Regla : %s\n", iptc_strerror(errno));
      result=iptc_commit(&handle);//ejecuta la accion
      if(result == 0)
          printf("Commit error en Crear Regla: %s\n", iptc_strerror(errno));
      else
         printf("\nExito al crear un nueva Regla en filter\n");
//      SetRedirect(cp,"nat","DNAT","PREROUTING","192.188.59.12");
      free(chain_entry);
      return result;

  }  //fin de GetExisteRegla

} // Verifica que la ip distinto de cero
else
free(chain_entry);

return 0;

}

i put the rules with the function and inside the packet have ipsrc, ipdst y 
protocol .

SetNuevaRegla(packet,"filter","FORWARD");

the above rule is like in the following script
iptables -s 1.2.3.4 -d 1.4.5.6 -p all|tcp|udp -j DROP or ACCEPT


Ok all work very well i don't put script ,the program automatic put the rule 
based in some data .

BUT The PROBLEM IS :


THE PROBLEM IS THAT libiptc.a DON'T  SUPPORT TABLES LIKE "nat" and of course
I can't put rules with this library

The main of this is I want to REDIRECT some packets ,put this rule
itpables -t nat -A PREROUTING -s 1.2.3.4 -d 1.6.7.8 -p tcp --dport 80 -j 
DNAT
but with the program NOT with scripts .

I read the iptables source code and this program load dinamic library for 
example
libipt_tcpmss.so libipt_SNAT.so etc...  in folter extensions
and put the rule like the above i think

Please can anybody help me!!!! a response HOW i can put rules in table nat , 
and HOW TO put rules whith port TCP like 80(HTTP),53(DNS),23(TELNET) with 
programming NOT with scripts.


I will be grateful for you help

Thank you Developers




_________________________________________________________________
Protect your PC - get McAfee.com VirusScan Online 
http://clinic.mcafee.com/clinic/ibuy/campaign.asp?cid=3963
